require 'rails_helper'

RSpec.describe "Login", type: :feature, js: true do
  def sign_in
    OmniAuth.config.add_mock(:gplus, {uid:'12345',info: {email:"mfazekas@szemafor.com",firt_name:"Miklos",last_name:"Fazekas"}})
    visit "/auth/gplus"
  end
  describe "GET /" do
    it "works! (now write some real specs)" do
      sign_in
      visit "/"
      expect(page).to have_content("foo")
    end
  end
end
