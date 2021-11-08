class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!

  def show
      @customer = current_customer
  end


  def edit
      @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to mypage_path, flash: {info: '会員情報を更新しました'}
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @customer = current_customer
    @customer.update(is_active: false)
    reset_session
    redirect_to root_path, flash: {success: '退会処理が完了しました。またのご利用を心よりお待ちしております！'}
  end

  private

  def set_current_customer
    @customer = current_customer
  end

   # 会員の論理削除のための記述。退会後は、同じアカウントでは利用できない。
  def reject_customer
    @customer = Customer.find_by(name: params[:customer][:email])
    if @customer
      if @customer.active_password?(params[:customer][:password]) && !@customer.is_active
        redirect_to new_customer_registration ,flash: {notice: "退会済みです。再度ご登録をしてご利用ください。"}
      else
        flash[:notice] = "項目を入力してください"
      end
    end
  end
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :first_name_kana, :last_name_kana, :email, :postal_code, :address, :telephone_number)
  end
end
