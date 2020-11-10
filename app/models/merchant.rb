class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :order_items, through: :items
  has_many :orders, through: :order_items
  has_many :users
  has_many :bulk_discounts
  has_many :addresses, through: :orders

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    orders.joins(:order_address)
          .joins(:address)
          .order('city_state')
          .distinct
          .pluck(Arel.sql("CONCAT_WS(', ', addresses.city, addresses.state) AS city_state"))
  end

  def pending_orders
    orders.where(status: 'pending')
  end

  def order_items_by_order(order_id)
    order_items.where(order_id: order_id)
  end

  def find_discount(item_quantity)
    bulk_discounts.where('required_quantity <= ?', item_quantity)
      .order(percent: :desc)
      .first
  end
end
