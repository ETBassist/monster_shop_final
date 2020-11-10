require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many(:orders).through(:order_addresses) }
  end

  describe 'validations' do
    it { should validate_presence_of :nickname }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe 'instance methods' do
    before :each do
      @user = create(:user)
      @address1 = @user.addresses.create(nickname: "My Crib",
                                        address: "123 Dope Street",
                                        city: "Boulder",
                                        state: "CO",
                                        zip: 12345)
      @address2 = @user.addresses.create(nickname: "Home",
                                        address: "246 Cozy Lane",
                                        city: "Boulder",
                                        state: "CO",
                                        zip: 12346)
      @order1 = @address1.orders.create!(user_id: @user.id,
                                        status: 1)
      @order2 = @address2.orders.create!(user_id: @user.id,
                                        status: 2)
      @order3 = @address1.orders.create!(user_id: @user.id,
                                        status: 3)
      @order4 = @address1.orders.create!(user_id: @user.id,
                                        status: 0)
    end

    it "#has_been_shipped_to?" do
      expect(@address1.has_been_shipped_to?).to eq(false)
      expect(@address2.has_been_shipped_to?).to eq(true)
    end
  end
end
