class Public::GenresController < ApplicationController

  def show
    @items = Genre.find(params[:id]).items.where(is_active: true).page(params[:page])
  end

end
