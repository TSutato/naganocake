class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!, only: [:create, :update, :destroy]

  def index
  @cart_items = current_customer.cart_items
  end

  def create
    if  current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id]).present?
      #trueであればカート内にある同じ商品の個数を増やす。
      @cart_item = current_customer.cart_items.find_by(item_id: params[:cart_item][:item_id])
      @new_amount = @cart_item.amount.to_i + params[:cart_item][:amount].to_i
      @cart_item.update(amount: @new_amount)
      redirect_to cart_items_path
    else
      #falseであれば新しくカートに追加する商品を記載。
      @cart_item = current_customer.cart_items.new(cart_item_params)
      if @cart_item.save
        redirect_to cart_items_path, flash: {info: 'カートに商品が追加されました'}
      else
        @item = Item.find(params[:cart_item][:item_id])
        render 'public/items/show'
      end
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path, flash: {info: '商品数量の変更を完了しました'}
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, flash: {warning: '削除しました'}
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path, flash: {secondary: 'カート内商品を全て削除しました'}
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end

end
