class Item < ApplicationRecord
  has_one_attached :item_image
  
  def get_item_image(width, heght)
    #unless item_image.attached?
    #  file_path = Rails.root.join('app/assets/images/no_image.jpg')
    #  item_image.attach(io: File.open(file_path), filename: 'default.jpg', content_type: 'image/jpeg')
    #end
    item_image.variant(resize_to_limit: [width, heght]).processed
  end
end
