class Admin::OrdersController < ApplicationController

	def edit
		@order = Order.find(params[:id])
		@customer = @order.customer
		@statuses = statuses
		@making_statuses = making_statuses
	end

	def update
		@order = Order.find(params[:id])
		update_order_status
		redirect_to edit_admin_order_path(@order.id)
	end

	def update_detail
		@item = OrderDetail.find(params[:id])
		@order = @item.order
		update_making_status
		redirect_to edit_admin_order_path(@order.id)
	end










	private
	
	def order_status_params
		params.require(:order).permit(:status)
	end

	def order_detail_status_params
		params.require(:order_detail).permit(:making_status)
	end

	def statuses
		statuses = []
		Order.statuses_i18n.each do |status|
			statuses.push([status[1], status[0]])
		end
		if @order.status == "in_producting"
			statuses.pop(2).shift(2)
		elsif @order.status == "no_payment" || @order.status == "paid"
			statuses.pop(3)
		elsif @order.status == "preparing_shipping" || @order.status == "shipped"
			statuses.shift(3)
		end
		return statuses
	end

	def making_statuses
		statuses = []
		OrderDetail.making_statuses_i18n.each do |status|
			statuses.push([status[1], status[0]])
		end
		if @order.status == "no_payment"
			statuses.pop(3)
		else
			statuses.shift
		end
		return statuses
	end
	
	def update_order_status
		@order.update(order_status_params)
		if @order.status == "paid"
			@order.order_details.each do |item|
				item.update(making_status: "not_yet_make")
			end
		elsif @order.status == "no_payment"
			@order.order_details.each do |item|
				item.update(making_status: "unmakable")
			end
		end
	end	

	def update_making_status
		@item.update(order_detail_status_params)
		item_all_status = @order.order_details.pluck(:making_status)
		if item_all_status.uniq == ["not_yet_make"]
			@order.update(status: "paid")
		elsif item_all_status.uniq == ["finished_producting"]
			@order.update(status: "preparing_shipping")
		else
			@order.update(status: "in_producting")
		end
	end

end
