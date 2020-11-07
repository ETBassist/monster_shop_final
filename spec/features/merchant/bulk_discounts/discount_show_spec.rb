require 'rails_helper'

feature 'Discount Show Page' do
  given!(:user) { @merchant_admin = create(:user, role: 1) }
  describe "When I visit a discount show page" do
    before :each do
      page.set_rack_session(user_id: @merchant_admin.id)
      @discount = @merchant_admin.bulk_discounts.create(percent: 0.5,
                                                        required_quantity: 199)
    end

    it "Has details about that discount" do
      visit "/merchant/bulk_discounts/#{@discount.id}"

      expect(page).to have_content(@discount.id)
      expect(page).to have_content(@discount.percent)
      expect(page).to have_content(@discount.required_quantity)
    end
  end
end
