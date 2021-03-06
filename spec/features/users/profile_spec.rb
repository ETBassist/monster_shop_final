require 'rails_helper'

RSpec.describe "User Profile Path" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @admin = User.create!(name: 'Megan', email: 'admin@example.com', password: 'securepassword')
      @address1 = @user.addresses.create!(nickname: 'Home', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @address2 = @user.addresses.create!(nickname: 'Home', address: '129 That Other St', city: 'Denver', state: 'CO', zip: 80235)
    end

    it "I can view my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@user.addresses.first.address)
      expect(page).to have_content("#{@user.addresses.first.city} #{@user.addresses.first.state} #{@user.addresses.first.zip}")
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit')
    end

    it "I can update my profile data" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Edit'

      expect(current_path).to eq('/profile/edit')

      name = 'New Name'
      email = 'new@example.com'

      fill_in "Name", with: name
      fill_in "Email", with: email
      click_button 'Update Profile'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
    end

    it "I can update my password" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Change Password'

      expect(current_path).to eq('/profile/edit_password')

      password = "newpassword"

      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_button 'Change Password'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')

      click_link 'Log Out'

      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      expect(page).to have_content("Your email or password was incorrect!")

      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: "newpassword"
      click_button 'Log In'

      expect(current_path).to eq(profile_path)
    end

    it "I must use a unique email address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/edit'

      fill_in "Email", with: @admin.email
      click_button "Update Profile"

      expect(page).to have_content("email: [\"has already been taken\"]")
      expect(page).to have_button "Update Profile"
    end

    it "I see all the addresses that I've created and a link to edit or delete them" do
      page.set_rack_session(user_id: @user.id)
      visit "/profile"

      within("#address-#{@address1.id}") do
        expect(page).to have_link("#{@address1.nickname}")
        expect(page).to have_link("Edit Address")
        click_link("Delete Address")
      end

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Address Deleted")

      expect(page).to_not have_css("#address-#{@address1.id}")

      within("#address-#{@address2.id}") do
        click_link("Edit Address")
      end

      expect(current_path).to eq("/profile/addresses/#{@address2.id}/edit")
    end

    it "If an address cannot be deleted a flash message is shown and the address is still there" do
      page.set_rack_session(user_id: @user.id)
      address2 = @user.addresses.create(nickname: "Home",
                                        address: "246 Cozy Lane",
                                        city: "Boulder",
                                        state: "CO",
                                        zip: 12346)
      address2.orders.create!(user_id: @user.id,
                              status: 2)
      visit "/profile"

      within("#address-#{address2.id}") do
        click_link("Delete Address")
      end

      expect(current_path).to eq("/profile")
      expect(page).to have_content("Cannot delete an address used in a shipped order")
      expect(page).to have_css("#address-#{address2.id}")
    end

    it "I see a link to view more details about an address" do
      page.set_rack_session(user_id: @user.id)
      visit "/profile"

      within("#address-#{@address1.id}") do
        click_link("#{@address1.nickname}")
      end

      expect(current_path).to eq("/profile/addresses/#{@address1.id}")
      expect(page).to have_content(@address1.nickname)
      expect(page).to have_content(@address1.address)
      expect(page).to have_content(@address1.city)
      expect(page).to have_content(@address1.state)
      expect(page).to have_content(@address1.zip)
    end

    it "I see a link to create a new address" do
      page.set_rack_session(user_id: @user.id)
      visit "/profile"
        
      click_link("New Address")
      expect(current_path).to eq("/profile/addresses/new")
    end
  end
end
