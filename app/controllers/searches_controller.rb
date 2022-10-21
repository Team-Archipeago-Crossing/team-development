class SearchesController < ApplicationController

  def search
    @items = Item.looks(params[:search]).page(params[:page])
    @genres = Genre.all
  end
  
end
