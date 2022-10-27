class Public::ItemsController < ApplicationController

	def index
		@items = Item.all
	end

	def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
    purchase_history = current_customer.past_order_details.reverse_order
    @order_times = purchase_history.count{|i| i.item_id == @item.id}
    @last_order = purchase_history.find_by(item_id: @item.id).order
	end

end
