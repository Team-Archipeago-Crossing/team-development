class Admin::ItemsController < ApplicationController

  def index
    @items = Item.page(params[:page])
  end

  def new
    @item = Item.new
    #@genres = Genre.all
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_path(@item), notice: "商品の新規登録に成功しました."
    else
      p @genre_selector = params[:item][:genre_id]
      render :new
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
    @genres = Genre.all
    @genre_selector = @item.genre_id
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      @item.cart_items.destroy_all unless @item.is_active
      redirect_to admin_item_path(@item), notice: "商品の編集が成功しました"
    else
      @genre_selector = params[:item][:genre_id]
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:item_image, :name, :introduction, :genre_id, :price, :is_active)
  end

end
