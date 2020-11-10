class Address < ApplicationRecord
  belongs_to :user
  has_many :order_addresses
  has_many :orders, through: :order_addresses

  validates_presence_of :nickname, :address, :city, :state, :zip

  def can_be_deleted?
    !orders.exists?(status: 2)
  end
end
