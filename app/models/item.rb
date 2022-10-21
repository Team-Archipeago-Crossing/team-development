class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  belongs_to :genre


  has_one_attached :item_image
  validates :is_active, inclusion: { in: [true, false] }


  def get_item_image
    (item_image.attached?) ? item_image : 'noimage.png'
  end
  
  
  def self.looks(search)
    Item.where("name LIKE?","%#{search}%")
  end

  def with_tax_price
    (price * $tax_rate).floor
  end

end