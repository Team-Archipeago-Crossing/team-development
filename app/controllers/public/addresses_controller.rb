class Public::AddressesController < ApplicationController

  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    if @address.save
      flash[:notice] = "配送先を登録しました。"
      redirect_to addresses_path
    else
      flash[:alret] = "項目を全て記入してください。"
      @addresses = current_customer.addresses.all
      render :index
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to addresses_path
  end

  def update
    address = Address.find(params[:id])
    if address.update(address_params)
      redirect_to addresses_path
      flash[:notice] = "変更を保存しました。"
    else
      flash[:alret] = "項目を全て記入してください。"
      @address = Address.find(params[:id])
      render :edit
    end
  end

  def index
    @address = Address.new
    @addresses = current_customer.addresses.all
  end



  def edit
    @address = Address.find(params[:id])
  end


  private
  def address_params
    params.require(:address).permit(:name,:postal_code,:address)
  end
end
