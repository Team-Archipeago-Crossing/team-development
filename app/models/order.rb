class Order < ApplicationRecord
	enum payment_method: {:credit => 0, :transfer => 1}
	
	has_many :order_details
	#belongs_to :customer
	
end
