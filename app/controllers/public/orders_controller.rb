class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_cart_items, only: [:new, :confirm, :create]

  def new
    @order = Order.new
  end

  def confirm
    @order = Order.new(order_params)
    if params[:order][:select_address] == '0'
      @order.get_shipping_info(current_customer)
    elsif params[:order][:select_address] == '1'
      @selected_address = current_customer.addresses.find(params[:order][:address_id])
      @order.get_shipping_info(@selected_address)
    elsif params[:order][:select_address] == '2' && @order.address_address? && (@order.address_postal_code =~ /\A\d{7}\z/) && @order.address_name?
      @order.address_address = params[:order][:address_address]
      @order.address_postal_code = params[:order][:address_postal_code]
      @order.address_name = params[:order][:address_name]
    else
      flash[:warning] = '情報を正しく入力して下さい。'
      redirect_to new_order_path
    end
  end


  def create
    @order = current_customer.orders.new(order_params)
    @order.shipping_cost = 800
    @cart_items = current_customer.cart_items.all
    @order.total_price = @order.shipping_cost + @cart_items.sum(&:subtotal)
    if @order.save
      @cart_items.each do |cart_item|
        @order_item = @order.order_items.new
        @order_item.item_id = cart_item.item_id
        @order_item.amount = cart_item.amount
        @order_item.price = cart_item.item.add_tax_price
        @order_item.save
      end
      current_customer.cart_items.destroy_all
      redirect_to thanks_path, flash: {info: '注文を承りました！'}
    else
      render :new
    end
  end
  
  def complete
		order = Order.new(session[:order])
		order.save

		if session[:new_address]
			shipping_address = current_customer.shipping_addresses.new
			shipping_address.postal_code = order.post_code
			shipping_address.address = order.address
			shipping_address.name = order.name
			shipping_address.save
			session[:new_address] = nil
		end

		# 以下、order_detail作成
		cart_items = current_customer.cart_items
		cart_items.each do |cart_item|
			order_detail = OrderDetail.new
			order_detail.order_id = order.id
			order_detail.item_id = cart_item.item.id
			order_detail.quantity = cart_item.quantity
			order_detail.making_status = 0
			order_detail.price = (cart_item.item.price_without_tax * 1.1).floor
			order_detail.save
	end

  def index
    @orders = current_customer.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:delivery_name, :delivery_postcode, :delivery_address, :payment_method)
  end

  def ensure_cart_items
    @cart_items = current_customer.cart_items.includes(:item)
    if @cart_items.empty?
      redirect_to items_path, flash: {danger: 'カートに商品を入れてください'}
    end
  end
end
