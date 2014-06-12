require 'rails_helper'

RSpec.describe "TimeEntries", type: :request do
  def sign_in
    OmniAuth.config.add_mock(:gplus, {uid:'12345',info: {email:"mfazekas@szemafor.com",firt_name:"Miklos",last_name:"Fazekas"}})
    #get new_session_path
    get "/auth/gplus"
    follow_redirect!
  end
  describe "GET /time_entries" do
    it "works! (now write some real specs)" do
      sign_in
      get time_entries_path
      expect(response.status).to be(200)
      expect(response.body).to eq('foo')
    end
  end
end
