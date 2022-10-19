class CartItemsController < ApplicationController

  def create
    customer = current_customer
  	cart_item = CartItem.new(cart_item_params)
  	cart_item.customer_id = customer.id #要変更
  	cart_item.save
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end

end
