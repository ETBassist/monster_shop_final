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

    it "if I fill in the fields and click submit I'm taken to my profile and I see success message" do
      visit '/profile/addresses/new'

      fill_in(:nickname, with: "My Crib")
      fill_in(:address, with: "123 Dope Street")
      fill_in(:city, with: "Awesome Town")
      fill_in(:state, with: "YO")
      fill_in(:zip, with: 12345)

      click_button("Create Address")

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Address Added")
      expect(@user.addresses.last.nickname).to eq("My Crib")
      expect(@user.addresses.last.address).to eq("123 Dope Street")
      expect(@user.addresses.last.city).to eq("Awesome Town")
      expect(@user.addresses.last.state).to eq("YO")
      expect(@user.addresses.last.zip).to eq(12345)
    end

    it "if I don't fill all the fields in I see a message and am returned to the page" do
      visit '/profile/addresses/new'

      fill_in(:nickname, with: "My Crib")
      fill_in(:address, with: "123 Dope Street")
      fill_in(:city, with: "Awesome Town")
      fill_in(:state, with: "YO")

      click_button("Create Address")

      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_field(:nickname, with: "My Crib")
      expect(page).to have_field(:address, with: "123 Dope Street")
      expect(page).to have_field(:city, with: "Awesome Town")
      expect(page).to have_field(:state, with: "YO")
    end
  end
end
