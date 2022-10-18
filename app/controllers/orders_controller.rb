class OrdersController < ApplicationController

	def new
		#customer = current_user
		@method_name = Order.payment_methods_i18n
		@addresses_list = addresses_pulldown
		@address = Address.new #customer.addresses.new
	end

	def confirm
		return redirect_to new_order_url if request.get?
		#customer = current_user
		@method = Order.payment_methods
		@method_name = Order.payment_methods_i18n
		@addresses_list = addresses_pulldown

		selected_address = Address.find_by(id: params[:address][:addresses_list].to_i)
		if !params[:address][:payment_method].nil?
			if params[:address][:select_address].to_i == 0
				@address = Address.find(0) #Address.new(address: customer.address, name: customer.name, postal_code: customer.postal_code)
			elsif params[:address][:select_address].to_i == 1 #&& selected_address.customer == current_user
				@address = selected_address
			elsif params[:address][:select_address].to_i == 2
				@address = Address.new(address_params)
				#@address = @user.addresses.new
			end
			@payment_method = params[:address][:payment_method]
			@items = CartItem.all #@customer.cart_items
			@subtotal = 0
			@items.each do |item|
				@subtotal += (item.item.price * $tax_rate).floor * item.amount
			end
			@shipping_cost = 800
			@total_payment = @subtotal + @shipping_cost

			$address = @address
			$payment_method = @payment_method
			$total_payment = @total_payment
			$shipping_cost = @shipping_cost
			$payment_method = @payment_method
		end

	end

	def create
		#customer = current_user
		order = Order.create(\
			customer_id: 0,\
			payment_method: $payment_method,\
			name: $address.name,\
			postal_code: $address.postal_code,\
			address: $address.address,\
			shipping_cost: $shipping_cost,\
			total_payment: $total_payment\
		)#current_user.orders.crate(...)
		cart_items = CartItem.all #@customer.cart_items
		cart_items.each do |item|
			order.order_details.create(item_id: item.item_id, amount: item.amount, price: item.item.price)
		end
		redirect_to complete_orders_url
	end

	private

	def addresses_pulldown
		list = [["選択してください...", false]]
		Address.all.each do |add| #customer.addresses.each do |add|
			postal_code = add.postal_code
			address = add.address
			name = add.name
			list_title = "〒#{postal_code}　#{address}　#{name}"
			list.push([list_title, add.id])
		end
		return list
	end

  def address_params
    params.require(:address).permit(:name, :address, :postal_code)
  end

	def order_info_validate

	end

	def reset_variable

	end

	def order_info_incomplete
		address_list = Address.find_by(id: params[:addresses_list])
		postal_code = params[:new_address_postal_code]
		address = params[:new_address_address]
		address_name = params[:address_name]

		radio_button_unchecked = params[:payment_method].nil? || params[:select_address].nil?
		addresses_list_incorrect = params[:select_address] == "1" && address_list.nil?# && address_list.customer_id == current_user.id
		new_address_incorrect = params[:select_address] == "2" && (postal_code.length != 7 || \
															postal_code.to_i == 0 || address == "" || address_name == "")
		result = radio_button_unchecked || addresses_list_incorrect || new_address_incorrect
		return result
	end
end
