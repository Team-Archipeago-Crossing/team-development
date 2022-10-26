class Admin::CustomersController < ApplicationController
	
	def index
		@customers = Customer.all
	end

	def show
		@customer = Customer.find(params[:id])
	end

	def edit
		@customer = Customer.find(params[:id])
	end
	
	def update
		@customer = Customer.find(params[:id])
		if @customer.update(customer_params)
			redirect_to admin_customer_path(params[:id]), notice: "会員情報を編集しました"
		else
			render :edit
		end
		#フラッシュメッセージ表示のため書き換えました
		#customer.update(customer_params) ? (redirect_to admin_customer_path(params[:id])) : (render :edit)
	end
	
	private
	def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :postal_code, :address, :telephone_number, :is_deleted)
  end
end
