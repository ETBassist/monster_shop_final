class Merchant::BulkDiscountsController < ApplicationController
  def index
    @discounts = BulkDiscount.where(user_id: current_user.id)
  end
end
