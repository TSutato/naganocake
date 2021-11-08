class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :confirm, :create]

  def new
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
    @cart_items = current_customer.cart_items
    #自分の住所を選択された時
    if params[:order][:select_address] == '0'
      @order.get_shipping_info(current_customer)
    #登録済の住所を選択された時
    elsif params[:order][:select_address] == '1'
      @selected_address = current_customer.addresses.find(params[:order][:address_id])
      @order.get_shipping_info(@selected_address)
    # 新しいお届け先が選択された時
    elsif params[:order][:select_address] == '2'
    #↓本来は21~23行目の記載不要だが動きを把握するために反映。
      @order.address = params[:order][:address]
      @order.postal_code = params[:order][:postal_code]
      @order.name = params[:order][:name]
    else
      flash[:warning] = '情報を正しく入力して下さい。'
      redirect_to new_order_path
    end
  end

  #order_details 部分作成
  def create
    @order = current_customer.orders.new(order_params)
    @order.shipping_cost = 800
    @cart_items = current_customer.cart_items.all
    @order.total_payment = @order.shipping_cost + @cart_items.sum(&:subtotal)
    if @order.save
      @cart_items.each do |cart_item|
        @order_detail = @order.order_details.new
        @order_detail.item_id = cart_item.item_id
        @order_detail.amount = cart_item.amount
        @order_detail.price = cart_item.item.with_tax_price
        @order_detail.save
      current_customer.cart_items.destroy_all
      end
      redirect_to complete_path, flash: {info: '注文を承りました！'}
    else
      render :new
    end
  end

  def complete

  end


  def index
    @orders = current_customer.orders
  end

  def show
    @order = current_customer.orders.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:name, :postal_code, :address, :payment_method)
  end


end
