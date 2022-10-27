class SearchesController < ApplicationController

  def search
    @items = Item.looks(params[:search])
    @genres = Genre.all
    @query = params[:search]
  end
  
end
