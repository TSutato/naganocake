class Admin::OrderDetailsController < ApplicationController
  before_action :authenticate_admin!

  def update
    @order_detail = OrderDetail.find(params[:id])
    @order = @order_detail.order
    if @order.status != "入金待ち"
      @order_detail.update(order_detail_params)
      @order_detail.change_order_status
      redirect_to admin_order_path(@order), flash: {success: "製作ステータスを更新しました！"}
    else
      flash[:warning] = "注文ステータスが「入金待ち」の為、変更できません"
      redirect_to admin_order_path(@order)
    end
  end

  private

  def order_detail_params
    params.require(:order_detail).permit(:making_status)
  end
end
