class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    quantity * price
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end

  def find_discount
    item.merchant.bulk_discounts.where('required_quantity <= ?', quantity)
      .order(percent: :desc)
      .first
  end
end
