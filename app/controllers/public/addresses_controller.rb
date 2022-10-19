class Public::AddressesController < ApplicationController

  def create
    @address = Address.new(address_params)
    @address.custmer_id = current_customer.id
    if @address.save
      redirect_to addresses_path
    else
      @addresses = Address.all
      render :index
    end
  end

  def index
    @address = Address.new
    # @customer = current_customer
    # @addresses = @customer.address.all
  end



  def edit
  end


  private
  def address_params
    params.require(:address).permit(:name,:postal_code,:address)
  end
end