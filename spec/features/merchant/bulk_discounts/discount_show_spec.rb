require 'rails_helper'

feature 'Discount Show Page' do
  given!(:user) { @merchant_admin = create(:user, role: 1) }
  describe "When I visit a discount show page" do
    before :each do
      @merchant = create(:merchant)
      @merchant_admin.update(merchant_id: @merchant.id)
      page.set_rack_session(user_id: @merchant_admin.id)
      @discount = @merchant.bulk_discounts.create(percent: 0.5,
                                                        required_quantity: 199)
    end

    it "Has details about that discount" do
      visit "/merchant/bulk_discounts/#{@discount.id}"

      expect(page).to have_content(@discount.id)
      expect(page).to have_content("#{(@discount.percent * 100).to_i}")
      expect(page).to have_content(@discount.required_quantity)
    end

    it "I see a link to edit that discount" do
      visit "/merchant/bulk_discounts/#{@discount.id}"

      click_link("Edit Discount")
      expect(current_path).to eq("/merchant/bulk_discounts/#{@discount.id}/edit")
    end
  end
end
