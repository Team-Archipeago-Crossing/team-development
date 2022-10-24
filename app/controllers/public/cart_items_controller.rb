class Public::CartItemsController < ApplicationController

  def create
    customer = current_customer
    cart_items = customer.cart_items
    if cart_items.pluck(:item_id).include?(params[:cart_item][:item_id].to_i)
      item = cart_items.find_by(item_id: params[:cart_item][:item_id].to_i)
      item.amount += params[:cart_item][:amount].to_i
      item.save
    else
      cart_item = CartItem.new(cart_item_params)
      cart_item.customer_id = customer.id
      cart_item.save
    end
  	redirect_to cart_items_path
  end

  def index
    calc_subtotal
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    calc_subtotal
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    @id = cart_item.item.id
    cart_item.destroy
    calc_subtotal
    @cart_items = @customer.cart_items
    #if @cart_items.count == 0
  end

  def destroy_all
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    render "destroy"
  end



  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end


def calc_subtotal
  @customer = current_customer
  @cart_items = @customer.cart_items
  @subtotal = 0
  @cart_items.each do |item|
    @subtotal += (item.item.price * $tax_rate).floor * item.amount
  end
end

end
