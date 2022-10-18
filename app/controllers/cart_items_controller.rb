class CartItemsController < ApplicationController
	
  def create
  	cart_item = CartItem.new(cart_item_params)
  	cart_item.customer_id = 0 #要変更
  	cart_item.save
  end
	
  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end
  
end
