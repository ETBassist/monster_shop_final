require 'rails_helper'

feature 'Bulk Discount Index' do
  given!(:user) { @merchant_admin = create(:user, role: 1) }
  describe "As a merchant admin when I visit my bulk items index" do
    before :each do
      page.set_rack_session(user_id: @merchant_admin.id)
    end

    it "I see all the bulk discounts I've created" do
      visit '/merchant/bulk_discounts'

    end
  end
end
