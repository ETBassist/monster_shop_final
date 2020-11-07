class Merchant::BulkDiscountsController < ApplicationController
  # before_action :require_merchant

  def index
    @discounts = BulkDiscount.where(merchant_id: current_user.merchant.id)
  end

  def show
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def create
    discount = BulkDiscount.new(percent: calculated_percent,
      required_quantity: params[:bulk_discount][:required_quantity],
      merchant_id: current_user.merchant.id)
    if discount.save
      flash[:success] = "Discount Created"
      redirect_to '/merchant/bulk_discounts'
    else
      flash.now[:notice] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update(percent: calculated_percent,
      required_quantity: params[:bulk_discount][:required_quantity])
    if @bulk_discount.save
      flash[:success] = "Discount Updated"
      redirect_to "/merchant/bulk_discounts/#{@bulk_discount.id}"
    else
      flash.now[:notice] = @bulk_discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/bulk_discounts"
  end

  private

  def calculated_percent
    params[:bulk_discount][:percent].to_i * 0.01 unless params[:bulk_discount][:percent].empty?
  end
end
