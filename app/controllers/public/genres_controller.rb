class Public::GenresController < ApplicationController

  def show
    genre = Genre.find(params[:id])
    @items = genre.items.where(is_active: true).page(params[:page])
  end

end
  