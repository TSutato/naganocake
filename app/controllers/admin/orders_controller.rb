class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @orders = Order.page(params[:page]).per(10)
  end

  def show
    @order = Order.find(params[:id])
    @order_details = @order.order_details
  end

  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
      @order.change_making_status
      redirect_to admin_order_path(@order), flash: {success: "注文ステータスを更新しました！"}
    else
      render :show
    end
  end

  def search
    @keyword = params[:keyword]
    @customers = Customer.customer_search(params[:keyword])
    @items = Item.item_search(params[:keyword])
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

end
