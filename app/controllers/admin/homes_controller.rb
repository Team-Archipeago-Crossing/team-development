class Admin::HomesController < ApplicationController
  
  def top
    @orders = Order.page(params[:page])
    if @custmoer_search = !params[:customer_id].nil?
      @customer = Customer.find(params[:customer_id]) 
      @orders = @customer.orders.page(params[:page]).per(10).order(created_at: :desc)
    else
      @orders = Order.page(params[:page]).per(10).order(created_at: :desc)
    end
  end
  
end
