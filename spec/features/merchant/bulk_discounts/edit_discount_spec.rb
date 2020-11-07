require 'rails_helper'

feature "Edit Discount Page" do
  given!(:user) { @merchant_admin = create(:user, role: 1) }
  describe "As a Merchant Employee" do
    before :each do
      page.set_rack_session(user_id: @merchant_admin.id)
      @discount = @merchant_admin.bulk_discounts.create!(percent: 0.5,
                                                         required_quantity: 100)
    end

    it "has a form with the fields prepopulated with the discounts details" do
      visit "/merchant/bulk_discounts/#{@discount.id}/edit"

      expect(page).to have_field(:percent, with: (@discount.percent * 100))
      expect(page).to have_field(:required_quantity, with: @discount.required_quantity)
    end
  end
end
