class AddressesController < ApplicationController
  def new
  end

  def create
    user = User.find(current_user.id)
    address = user.addresses.new(address_params)
    address.save
    flash[:success] = "Address Added"
    redirect_to '/profile'
  end

  private

  def address_params
    params.permit(:nickname, :address, :city, :state, :zip)
  end
end
