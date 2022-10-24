class ApplicationController < ActionController::Base
	before_action :authenticate_admin!, if: proc{controller_path.start_with?("admin")}
  before_action :authenticate_customer!, if: proc{["cart_items", "customers", "orders"].include?(controller_name)}

	def price_taxin(price)
		"￥ #{(price * $tax_rate).floor.to_s(:delimited)}"
	end

	def price(price)
		"￥ #{price.to_s(:delimited)}"
	end

	helper_method :price_taxin
	helper_method :price
end
