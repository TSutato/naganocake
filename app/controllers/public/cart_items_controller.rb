class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!, only: [:create, :update, :destroy]
  
  
  def index
  @cart_items = current_customer.cart_items
  end

  def create
    if @cart_item
      new_amount = @cart_item.amount + cart_item_params[:amount]
      @cart_item.update(amount: new_amount)
      redirect_to cart_items_path
    else
      @cart_item = current_customer.cart_items.new(cart_item_params)
      @cart_item.item_id = @item.id
      if @cart_item.save
        redirect_to cart_items_path, flash: {info: 'カートに商品が追加されました'}
      else
        render 'public/items/show'
      end
    end
  end

  def update
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path, flash: {info: '商品数量変更完了しました'}
  end

  def destroy
    @cart_item.destroy
    redirect_to cart_items_path, flash: {warning: '削除しました'}
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path, flash: {secondary: 'カート内商品を全て削除しました'}
  end

  private

  def cart_item_params
  params.require(:cart).permit(:item_id, :count)
  end
  
end
