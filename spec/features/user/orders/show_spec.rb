require 'rails_helper'
include ActionView::Helpers::NumberHelper

RSpec.describe 'Order Show Page' do
  describe 'As a Registered User' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @sal = Merchant.create!(name: 'Sals Salamanders', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @user = User.create!(name: 'Megan', email: 'megan_1@example.com', password: 'securepassword')
      @order_1 = @user.orders.create!(status: "packaged")
      @order_2 = @user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: true)
      @order_item_2 = @order_2.order_items.create!(item: @giant, price: @hippo.price, quantity: 5, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @address1 = Address.create(nickname: 'home',
                                address: '123 Dope St',
                                city: 'Awesome Town',
                                state: 'YO',
                                zip: 12345,
                                user_id: @user.id)
      OrderAddress.create!(order_id: @order_1.id,
                           address_id: @address1.id)
      OrderAddress.create!(order_id: @order_2.id,
                           address_id: @address1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    end

    it 'I can link from my orders to an order show page' do
      visit '/profile/orders'

      click_link "#{@order_1.id}"

      expect(current_path).to eq("/profile/orders/#{@order_1.id}")
    end

    it 'I see order information on the show page' do
      visit "/profile/orders/#{@order_2.id}"

      expect(page).to have_content(@order_2.id)
      expect(page).to have_content("Created On: #{@order_2.created_at}")
      expect(page).to have_content("Updated On: #{@order_2.updated_at}")
      expect(page).to have_content("Status: #{@order_2.status}")
      expect(page).to have_content("#{@order_2.count_of_items} items")
      expect(page).to have_content("Total: #{number_to_currency(@order_2.grand_total)}")

      within "#order-item-#{@order_item_2.id}" do
        expect(page).to have_link("#{@order_item_2.item.name}")
        expect(page).to have_content(@order_item_2.item.description)
        expect(page).to have_content(@order_item_2.quantity)
        expect(page).to have_content(@order_item_2.price)
        expect(page).to have_content(@order_item_2.subtotal)
      end

      within "#order-item-#{@order_item_3.id}" do
        expect(page).to have_link("#{@order_item_3.item.name}")
        expect(page).to have_content(@order_item_3.item.description)
        expect(page).to have_content(@order_item_3.quantity)
        expect(page).to have_content(@order_item_3.price)
        expect(page).to have_content(@order_item_3.subtotal)
      end
    end

    it 'I see a link to cancel an order, only on a pending order show page' do
      visit "/profile/orders/#{@order_1.id}"

      expect(page).to_not have_button('Cancel Order')

      visit "/profile/orders/#{@order_2.id}"

      expect(page).to have_button('Cancel Order')
    end

    it 'I can cancel an order to return its contents to the items inventory' do
      visit "/profile/orders/#{@order_2.id}"

      click_button 'Cancel Order'

      expect(current_path).to eq("/profile/orders/#{@order_2.id}")
      expect(page).to have_content("Status: cancelled")

      @giant.reload
      @ogre.reload
      @order_item_2.reload
      @order_item_3.reload

      expect(@order_item_2.fulfilled).to eq(false)
      expect(@order_item_3.fulfilled).to eq(false)
      expect(@giant.inventory).to eq(8)
      expect(@ogre.inventory).to eq(7)
    end

    it 'I see an items discounted price if it qualifies for a discount' do
      discount = @megan.bulk_discounts.create!(percent: 0.1,
                                               required_quantity: 4)
      expected_amount = number_to_currency(@order_item_2.subtotal - (@order_item_2.subtotal * discount.percent))

      visit "/profile/orders/#{@order_2.id}"

      within("#order-item-#{@order_item_2.id}") do
        expect(page).to have_content("Discounted Subtotal: #{expected_amount}")
      end

      within("#order-item-#{@order_item_3.id}") do
        expect(page).to have_content("Subtotal: #{number_to_currency(@order_item_3.subtotal)}")
      end
    end

    it 'I see a button to update the address if the status is not shipped' do
      address2 = Address.create(nickname: 'work',
                                address: '221B Baker St',
                                city: 'London',
                                state: 'UK',
                                zip: 10000,
                                user_id: @user.id)
      
      visit "/profile/orders/#{@order_2.id}"

      within('#shipping-address') do
        expect(page).to have_content(@address1.nickname)
        expect(page).to have_content(@address1.address)
        expect(page).to have_content(@address1.city)
        expect(page).to have_content(@address1.state)
        expect(page).to have_content(@address1.zip)
      end

      expect(page).to have_select(:addresses, with_options: [@address1.nickname, address2.nickname])
      select('work', from: :addresses)
      click_button('Change Address')
      expect(current_path).to eq("/profile/orders/#{@order_2.id}")
      expect(page).to have_content('Address Changed')

      within('#shipping-address') do
        expect(page).to have_content(address2.nickname)
        expect(page).to have_content(address2.address)
        expect(page).to have_content(address2.city)
        expect(page).to have_content(address2.state)
        expect(page).to have_content(address2.zip)
      end
    end

    it 'I do not see a form to update the address if the order is shipped' do
      @order_2.update(status: 2)
      @order_2.reload
      visit "/profile/orders/#{@order_2.id}"

      expect(page).to_not have_css("#change-address")
    end
  end
end
