class Admin::HomesController < ApplicationController


  def top
    if @custmoer_search = !params[:customer_id].nil?
      @customer = Customer.find(params[:customer_id])
      @orders = @customer.orders.order(created_at: :DESC).page(params[:page]).per(10)
    else
      @orders = Order.order(created_at: :DESC).page(params[:page]).per(10)
    end
  end

end
