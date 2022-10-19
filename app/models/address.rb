class Address < ApplicationRecord
	#belongs_to :customer
	validates :postal_code, presence: true, length: {is: 7}, numericality: true
	validates :address, presence: true
	validates :name, presence: true


end
