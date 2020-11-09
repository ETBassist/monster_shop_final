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
  end
end
