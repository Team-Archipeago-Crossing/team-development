class ApplicationController < ActionController::Base
	def price_taxin(price)
		"￥ #{(price * $tax_rate).floor.to_s(:delimited)}"
	end
	
	def price(price)
		"￥ #{price.to_s(:delimited)}"
	end
	
	helper_method :price_taxin
	helper_method :price
end
