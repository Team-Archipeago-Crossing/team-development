class ItemsController < ApplicationController
	
	def index
		@items = Item.page(params[:page])
	end
	
	def show
    @item = Item.find(params[:id])
    @cart_items = [] #item.cart_items.new
	end
  
end
