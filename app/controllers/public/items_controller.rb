class Public::ItemsController < ApplicationController
 

  def index
    @genres = Genre.all
    if params[:genre_id]
      @genre = @genres.find(params[:genre_id])
      @items = @genre.items.page(params[:page]).per(8)
    else
      @items = Item.page(params[:page]).per(8)
    end
  end

  

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end
end
