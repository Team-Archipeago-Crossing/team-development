class Public::CartItemsController < ApplicationController

  def create
    customer = current_customer
    cart_items = current_customer.cart_items
    item_id = params[:cart_item][:item_id]
    return redirect_back fallback_location: item_path(item_id) unless Item.find(item_id).is_active
    if cart_items.pluck(:item_id).include?(item_id.to_i)
      cart_item = cart_items.find_by(item_id: item_id)
      cart_item.amount += params[:cart_item][:amount].to_i
    else
      cart_item = CartItem.new(cart_item_params)
      cart_item.customer_id = customer.id
    end
    cart_item.save
  	redirect_to cart_items_path
  end

  def index
    calc_subtotal
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    calc_subtotal
    flash[:notice] = "変更を保存しました。"
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    @id = cart_item.item.id
    cart_item.destroy
    calc_subtotal
    @cart_items = @customer.cart_items
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
