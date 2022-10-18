class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  #belongs_to :genre

  has_one_attached :item_image

  def get_item_image
    (item_image.attached?) ? profile_image : 'noimage.png'
  end

end