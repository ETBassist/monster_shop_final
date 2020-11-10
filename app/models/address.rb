class Address < ApplicationRecord
  belongs_to :user
  has_many :order_addresses, dependent: :destroy
  has_many :orders, through: :order_addresses

  validates_presence_of :nickname, :address, :city, :state, :zip

  def has_been_shipped_to?
    orders.exists?(status: 2)
  end
end
