require 'rails_helper'

RSpec.describe OrderItem do
  describe 'relationships' do
    it {should belong_to :order}
    it {should belong_to :item}
  end

  describe 'instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!
      @order_2 = @user.orders.create!
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2)
      @order_item_2 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 3)
      @order_item_3 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 27)
    end

    it '.subtotal' do
      expect(@order_item_1.subtotal).to eq(40.5)
      expect(@order_item_2.subtotal).to eq(150)
      expect(@order_item_3.subtotal).to eq(1350)
    end

    it '.fulfillable?' do
      expect(@order_item_1.fulfillable?).to eq(true)
      expect(@order_item_3.fulfillable?).to eq(false)
    end

    it '.fulfill' do
      @order_item_1.fulfill

      @order_item_1.reload
      @ogre.reload
      expect(@order_item_1.fulfilled).to eq(true)
      expect(@ogre.inventory).to eq(3)
    end

    it '.find_discount' do
      @brian.bulk_discounts.create!(percent: 0.05,
                                    required_quantity: 10)
      discount2 = @brian.bulk_discounts.create!(percent: 0.55,
                                                required_quantity: 20)
      expect(@order_item_3.find_discount).to eq(discount2)
      expect(@order_item_1.find_discount).to eq(nil)
    end

    it '.total_after_discount' do
      discount1 = @brian.bulk_discounts.create!(percent: 0.25,
                                                required_quantity: 10)
      expected = @order_item_1.subtotal - (@order_item_1.subtotal * discount1.percent)
      expect(@order_item_1.total_after_discount).to eq(expected)
    end
  end
end
