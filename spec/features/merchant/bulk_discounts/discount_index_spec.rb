require 'rails_helper'

feature 'Bulk Discount Index' do
  given!(:user) { @merchant_admin = create(:user, role: 1) }
  describe "As a merchant admin when I visit my bulk items index" do
    before :each do
      @merchant = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant_admin.update(merchant_id: @merchant.id)
      page.set_rack_session(user_id: @merchant_admin.id)
      @merchant_admin2 = create(:user, role: 1)
      @discount1 = @merchant.bulk_discounts.create!(percent: 0.05,
                                                          required_quantity: 10)
      @discount2 = @merchant.bulk_discounts.create!(percent: 0.55,
                                                          required_quantity: 20)
      @discount3 = @merchant2.bulk_discounts.create!(percent: 0.55,
                                                           required_quantity: 20)
    end

    it "I see all the bulk discounts I've created" do
      visit '/merchant/bulk_discounts'

      within("#discount-#{@discount1.id}") do
        expect(page).to have_content(@discount1.id)
        expect(page).to have_content("#{(@discount1.percent * 100).to_i}")
        expect(page).to have_content(@discount1.required_quantity)
      end

      within("#discount-#{@discount2.id}") do
        expect(page).to have_content(@discount2.id)
        expect(page).to have_content("#{(@discount2.percent * 100).to_i}")
        expect(page).to have_content(@discount2.required_quantity)
      end

      expect(page).to_not have_selector("#discount-#{@discount3.id}")
    end

    it 'I see a link to create a new discount' do
      visit '/merchant/bulk_discounts'

      click_link("New Discount")

      expect(current_path).to eq("/merchant/bulk_discounts/new")
    end

    it 'I see each discounts id is a link to its show page' do
      visit '/merchant/bulk_discounts'

      within("#discount-#{@discount1.id}") do
        click_link("Discount #{@discount1.id}")
      end

      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount1.id}")
    end

    it 'I see a link to delete a discount' do
      visit '/merchant/bulk_discounts'
      
      within("#discount-#{@discount1.id}") do
        click_button("Delete #{@discount1.id}")
      end

      expect(current_path).to eq('/merchant/bulk_discounts')
      expect(page).to_not have_selector("#discount-#{@discount1.id}")

      expect(page).to have_selector("#discount-#{@discount2.id}")
    end
  end
end
