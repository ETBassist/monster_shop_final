class Address < ApplicationRecord
  belongs_to :user
  has_many :order_addresses
  has_many :orders, through: :order_addresses

  validates_presence_of :nickname, :address, :city, :state, :zip
end
