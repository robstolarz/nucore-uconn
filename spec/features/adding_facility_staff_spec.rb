require "rails_helper"

RSpec.describe "Adding/Removing Facility Staff" do
  fixtures :all
  # fixtures :facilities, :users, :user_roles

  let(:facility) { facilities(:facility) }
  let(:admin) { users(:facility_admin) }
  let(:normal_user) { users(:normal_user) }

  before { login_as admin }

  describe "adding a staff member", :js do
    before do
      visit facility_facility_users_path(facility)
      click_link "Add Facility Staff"
      fill_in "search_term", with: normal_user.first_name
      click_button "Search"
    end

    it "has the user and I can add them" do
      click_link normal_user.last_first_name
      expect(page).to have_content "Grant"

      click_button "Create"

      expect(current_path).to eq(facility_facility_users_path(facility))
      expect(page).to have_content(normal_user.full_name)
    end
  end

end