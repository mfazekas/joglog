require 'rails_helper'

RSpec.describe "TimeEntries", type: :api do
  before do
    log_in uid:'1234'
    @user = get_user_for_uid('1234')
  end

  describe "GET /time_entries" do

    it "returns and empty list" do
      get time_entries_path, format: :json
      expect(response.status).to be(200)
      expect(json).to eq([])
    end
  
    it "returns time_entires" do
      date = DateTime.now.in_time_zone
      date_as_json_string = JSON.parse([date].to_json)[0]
      
      @user.time_entries.create date:date, time:20.seconds, distance:100
      get time_entries_path, format: :json
      expect(response.status).to be(200)    
      expect(json).to eq([{'date'=>date_as_json_string,"time"=>20,"distance"=>100}])
    end
  end
end
