class Public::OrdersController < ApplicationController

	def index
		return redirect_to root_path unless customer_signed_in?
		customer = current_customer
		@orders = customer.orders.reverse
	end

	def show
		return redirect_to root_path unless customer_signed_in?
		@order = Order.find(params[:id])
		@subtotal = 0
		@order.order_details.each do |item|
			@subtotal += (item.item.price * $tax_rate).floor * item.amount
		end
	end

	def new
		return redirect_to root_path unless customer_signed_in?
		@customer = current_customer
		return redirect_to orders_path if @customer.cart_items.count == 0
		@method_name = Order.payment_methods_i18n
		@addresses_list = addresses_pulldown
		@address = @customer.addresses.new
		@address_params = {}
	end

	def confirm
		return redirect_to root_path unless customer_signed_in?
		return if @http_get = request.get?
		new
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
		customer = current_customer
		cart_items = customer.cart_items

		$order.save
		cart_items.each do |item|
			$order.order_details.create(item_id: item.item_id, amount: item.amount, price: item.item.price)
		end
		cart_items.destroy_all
		reset_temporary_data
		redirect_to complete_orders_url
	end










	private

	def addresses_pulldown
		list = [["選択してください...", false]]
		@customer.addresses.each do |add|
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
		$order = @customer.orders.new

		selected_address = Address.find_by(id: params[:address][:addresses_list].to_i)
		if params[:address][:select_address].to_i == 0
			using_address = Address.new(address: @customer.address, name: "#{@customer.last_name} #{@customer.first_name}", postal_code: @customer.postal_code)
		elsif params[:address][:select_address].to_i == 1 && selected_address.customer == @customer
			using_address = selected_address
		elsif params[:address][:select_address].to_i == 2
			using_address = @customer.addresses.new(address_params)
		end

		$order.name = using_address.name
		$order.postal_code = using_address.postal_code
		$order.address = using_address.address
		$order.payment_method = params[:address][:payment_method]

		@items = CartItem.all #@customer.cart_items
		@subtotal = 0
		@items.each do |item|
			@subtotal += (item.item.price * $tax_rate).floor * item.amount
		end
		$order.shipping_cost = 800
		$order.total_payment = @subtotal + $order.shipping_cost
		@order = $order
	end

	def reset_temporary_data
		$order = nil
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
