class Merchant::BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.where(user_id: current_user.id)
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    discount = BulkDiscount.new(percent: calculated_percent,
      required_quantity: params[:bulk_discount][:required_quantity],
      user_id: current_user.id)
    if discount.save
      flash[:success] = "Discount Created"
      redirect_to '/merchant/bulk_discounts'
    else
      flash.now[:notice] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def discount_params
    params.require(:bulk_discount).permit(:percent, :required_quantity)
  end

  def calculated_percent
    params[:bulk_discount][:percent].to_i * 0.01
  end
end
