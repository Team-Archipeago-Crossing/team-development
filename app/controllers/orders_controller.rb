class OrdersController < ApplicationController

	def new
		#customer = current_user
		return redirect_to items_url if CartItem.count == 0 #customer.cart_items.count == 0
		@method_name = Order.payment_methods_i18n
		@addresses_list = addresses_pulldown
		@address = Address.new #customer.addresses.new
		@address_params = {}
	end

	def confirm
		return redirect_to new_order_url if request.get?
		#customer = current_user
		@method_name = Order.payment_methods_i18n
		@addresses_list = addresses_pulldown
		@address = Address.new #customer.addresses.new

		@method = Order.payment_methods
		@method_name = Order.payment_methods_i18n
		@addresses_list = addresses_pulldown

		if @vaildate = order_info_incomplete
			@select_address_value = params[:address][:select_address]
			@payment_method_value = params[:address][:payment_method]
			@addresses_list_value = params[:address][:addresses_list]
			@address_params = address_params
			render "new"
		else
			save_temporary_data
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
		CartItem.destroy_all #@customer.cart_items.destrroy_all
		reset_temporary_data
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

	def save_temporary_data
		#customer = current_user
		selected_address = Address.find_by(id: params[:address][:addresses_list].to_i)
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
	end

	def reset_temporary_data
		$address, $payment_method, $total_payment, $shipping_cost = nil
	end

	def order_info_incomplete
		par = params[:address]
		address_list = Address.find_by(id: par[:addresses_list])
		postal_code = par[:postal_code]
		address = par[:address]
		address_name = par[:name]
		@payment_method_unchecked = par[:payment_method].nil?
		@select_address_unchecked = par[:select_address].nil?
		@addresses_list_incorrect = par[:select_address] == "1" && address_list.nil?# && address_list.customer_id == current_user.id
		@postal_code_incorrect = par[:select_address] == "2" && (postal_code.length != 7 || (postal_code =~ /\A[0-9]+\z/) == nil)
		@address_blank = par[:select_address] == "2" && address == ""
		@name_blank = par[:select_address] == "2" && address_name == ""
		result = @payment_method_unchecked || @select_address_unchecked || @addresses_list_incorrect || @postal_code_incorrect || @name_blank || @address_blank
		return result
	end
end
