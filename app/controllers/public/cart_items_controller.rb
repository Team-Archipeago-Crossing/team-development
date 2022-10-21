class Public::CartItemsController < ApplicationController

  def create
    customer = current_customer
  	cart_item = CartItem.new(cart_item_params)
  	cart_item.customer_id = customer.id #要変更
  	cart_item.save
  end

  def index
    @customer = current_customer
    @cart_items = @customer.cart_items.all
    @total = 0
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    @customer = current_customer
    @cart_items = @customer.cart_items.all
    redirect_to cart_items_path
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    @customer = current_customer
    @cart_items = @customer.cart_items.all
    redirect_to cart_items_path
  end

  def destroy_all
    if CartItem.destroy_all
       @customer = current_customer
       @cart_items = @customer.cart_items.all
       redirect_to cart_items_path
    else
      render :index
    end
  end



  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end

end
