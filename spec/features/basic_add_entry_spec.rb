require 'rails_helper'

RSpec.describe "Login", type: :feature, js: true do
  def sign_in
    OmniAuth.config.add_mock(:gplus, {uid:'12345',info: {email:"mfazekas@szemafor.com",firt_name:"Miklos",last_name:"Fazekas"}})
    visit "/auth/gplus"
  end

  describe "signin" do
    it "shows time entry list" do
      sign_in
      visit "/"
      expect(page).to have_content("Time entries")
    end
  end
  
  describe "add_entry" do
    it "shows time entry list" do
      sign_in
      visit "/"
      expect(page).to have_content("Time entries")
      expect(page).not_to have_content('12.3 kilometers')
      expect(page).not_to have_content('12.3 km/h')
      click_button("New entry")
      
      # create an entry without time/distance filled
      click_button("Create Time entry")
      expect(page).to have_css('div.form-group.time.has-error')
      expect(page).to have_css('div.form-group.distance.has-error')
      
      # fill in time/distance
      fill_in('Distance',with:'12300')
      fill_in("Time",with: "60")
      click_button("Create Time entry")
      
      # check if we see item
      expect(page).to have_content('Time entries')
      expect(page).to have_content('12.3 kilometers')
      expect(page).to have_content('12.3 km/h')

      # add another
      click_button("New entry")
      fill_in('Distance',with:'10000')
      fill_in("Time",with: "60")
      click_button("Create Time entry")

      # switch to weekly
      click_link("Weekly")

      expect(page).to have_content('Weekly report')
      expect(page).to have_content('22.3 kilometers') 
      expect(page).to have_content('11.2 km/h')
    end
  end
end
