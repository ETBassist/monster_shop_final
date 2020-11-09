require 'rails_helper'

feature "User/Addresses/Edit" do
  given!(:user) { @user = create(:user) }
  describe 'As a User' do
    before :each do
      page.set_rack_session(user_id: @user.id)
      @address = @user.addresses.create!(nickname: "My Crib",
                                         address: "123 Dope Street",
                                         city: "Awesome Town",
                                         state: "YO",
                                         zip: 12345)
    end

    it "I can visit a page to edit an address with the previous values shown" do
      visit "/profile/addresses/#{@address.id}/edit"

      expect(page).to have_field(:nickname, with: @address.nickname)
      expect(page).to have_field(:address, with: @address.address)
      expect(page).to have_field(:city, with: @address.city)
      expect(page).to have_field(:state, with: @address.state)
      expect(page).to have_field(:zip, with: @address.zip)
    end

    it "I can fill in a field and click submit to update an address and be taken to my profile" do
      new_address = "321 Slightly Less Dope Way"
      visit "/profile/addresses/#{@address.id}/edit"

      fill_in(:address, with: new_address)

      click_button("Update Address")

      expect(current_path).to eq("/profile")

      expect(@user.addresses.last.address).to eq(new_address)
    end

    it "If I fill in a field with nothing I'm returned to the page and see a flash message" do
      visit "/profile/addresses/#{@address.id}/edit"

      fill_in(:city, with: nil)

      click_button("Update Address")

      expect(page).to have_content("City can't be blank")
    end
  end
end
