require 'rails_helper'

feature 'Bulk Discount Index' do
  given!(:user) { @merchant_admin = create(:user, role: 1) }
  describe "As a merchant admin when I visit my bulk items index" do
    before :each do
      page.set_rack_session(user_id: @merchant_admin.id)
      @merchant_admin2 = create(:user, role: 1)
      @discount1 = @merchant_admin.bulk_discounts.create!(percent: 0.05,
                                                          required_quantity: 10)
      @discount2 = @merchant_admin.bulk_discounts.create!(percent: 0.55,
                                                          required_quantity: 20)
      @discount3 = @merchant_admin2.bulk_discounts.create!(percent: 0.55,
                                                           required_quantity: 20)
    end

    it "I see all the bulk discounts I've created" do
      visit '/merchant/bulk_discounts'

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.id)
        expect(page).to have_content(@discount1.percent)
        expect(page).to have_content(@discount1.required_quantity)
      end

      within("#discount-#{@discount2.id}") do
        expect(page).to have_content(@discount2.id)
        expect(page).to have_content(@discount2.percent)
        expect(page).to have_content(@discount2.required_quantity)
      end

      expect(page).to_not have_selector("#discount-#{@discount3.id}")
    end

    it 'I see a link to create a new discount' do
      visit '/merchant/bulk_discounts'

      click_link("New Discount")

      expect(current_path).to eq("/merchant/bulk_discounts/new")
    end
  end
end
