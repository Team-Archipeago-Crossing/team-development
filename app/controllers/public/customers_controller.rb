class Public::CustomersController < ApplicationController
  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    customer = current_customer
    if customer.update(customer_params)
      redirect_to customers_path, notice: "会員情報の編集に成功しました."
    else
      @customer = current_customer
      render :edit
    end
  end

  def disable
    customer = current_customer
    customer.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  def customer_params
    params.require(:customer).permit(:last_name,:first_name,:last_name_kana,:first_name_kana,:email,:postal_code,:address,:telephone_number,:encrypted_password,:is_deleted)
  end
end