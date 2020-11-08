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
    item.find_discount(quantity)
  end

  def total_after_discount
    subtotal - (find_discount.percent * subtotal)
  end
end
