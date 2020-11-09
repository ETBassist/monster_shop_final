class AddressesController < ApplicationController
  before_action :require_user

  def new
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    user = User.find(current_user.id)
    @address = user.addresses.new(address_params)
    if @address.save
      flash[:success] = "Address Added"
      redirect_to '/profile'
    else
      flash[:notice] = @address.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end
end
