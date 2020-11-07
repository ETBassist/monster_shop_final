require 'rails_helper'

feature 'New Discount Page' do
  given!(:user) { @merchant_admin = create(:user, role: 1) }
  describe 'As a merchant admin user' do
    before :each do
      page.set_rack_session(user_id: @merchant_admin.id)
    end

    it 'I can fill in a form to create a new discount' do
      visit '/merchant/bulk_discounts/new'

      fill_in(:percent, with: 10)
      fill_in(:required_quantity, with: 10)
      click_button("Create Bulk Discount")
      expect(current_path).to eq('/merchant/bulk_discounts')
      expect(page).to have_content("Discount Created")
    end

    it "if I fill in a form incorrectly I'm returned to the page and I see a message" do
      visit '/merchant/bulk_discounts/new'

      fill_in(:percent, with: 10)
      click_button("Create Bulk Discount")
      expect(page).to have_content("Required quantity can't be blank")
    end
  end
end
