class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!, only: [:edit, :update, :destroy]

  def index
    @address = Address.new
    @addresses = current_customer.addresses
  end

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to addresses_path, flash: {success: '配送先を登録しました'}
    else
      @addresses = current_customer.addresses
      render :index
    end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      redirect_to addresses_path, flash: {info: '配送先情報を変更しました'}
    else
      render :edit
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to addresses_path, flash: {secondary: '配送先を削除しました'}
  end

  private

  def address_params
    params.require(:address).permit(:name, :address, :postal_code)
  end



end
