class OrderDetail < ApplicationRecord
	enum making_status: {:unmakable => 0, :not_yet_make => 1, :in_producting => 2, :finished_producting => 3}

	belongs_to :order
	belongs_to :item
end
