require 'rails_helper'

feature "User/Addresses/New" do
  given!(:user) { @user = create(:user) }
  describe 'As a User' do
    before :each do
      page.set_rack_session(user_id: @user.id)
    end

    it "I see a form to create a new address" do
      visit '/profile/addresses/new'

      expect(page).to have_field(:nickname)
      expect(page).to have_field(:address)
      expect(page).to have_field(:city)
      expect(page).to have_field(:state)
      expect(page).to have_field(:zip)
    end
  end
end
