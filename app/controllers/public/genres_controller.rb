class Public::GenresController < ApplicationController

  def show
    @items = Genre.find(params[:id]).items
  end

end
