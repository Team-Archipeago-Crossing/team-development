class Order < ApplicationRecord
	enum payment_method: {:credit => 0, :transfer => 1}
	enum status: {:no_payment => 0, :paid => 1, :in_producting => 2, :preparing_shipping => 3, :shipped => 4}
	
	has_many :order_details, dependent: :destroy
	belongs_to :customer
	
end
