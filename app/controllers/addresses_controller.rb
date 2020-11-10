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

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
      flash[:success] = "Address Updated"
      redirect_to '/profile'
    else
      flash[:notice] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    address = Address.find(params[:id])
    if address.can_be_deleted?
      address.destroy
      flash[:success] = "Address Deleted"
    end
    redirect_to '/profile'
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :address, :city, :state, :zip)
  end
end
