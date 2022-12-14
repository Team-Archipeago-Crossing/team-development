class Public::HomesController < ApplicationController
  def top
    @items = get_latest_items(4)
    @genres = Genre.all
  end
  

  private

  def get_latest_items(num)
    all = Item.all.order(created_at: :DESC)
    all.slice(0...num)
  end

end
