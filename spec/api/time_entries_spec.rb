require 'rails_helper'

RSpec.describe "TimeEntries", type: :api do
  before do
    log_in uid:'1234'
    @user = get_user_for_uid('1234')
    expect(@user.time_entries.count).to eq(0)
  end

  describe "GET /time_entries" do
    it "returns and empty list" do
      get "/time_entries", format: :json

      expect(response.status).to be(200)
      expect(json).to eq([])
    end
  
    it "returns time_entires" do
      date = DateTime.now.beginning_of_minute.in_time_zone
      date_as_json_string = JSON.parse([date].to_json)[0]
      
      @user.time_entries.create date:date, time:20.seconds, distance:100

      get "/time_entries", format: :json
      expect(response.status).to be(200)    
      expect(json).to eq([{'date'=>date_as_json_string,"time"=>20,"distance"=>100}])
    end
  end

  describe "POST /time_entires" do
    it "adds a new time entry" do
      date=DateTime.now.beginning_of_minute

      post "/time_entries", time_entry:{distance:1200,time:200,date:date.iso8601()}, format: :json

      expect(response.status).to be(200)
      expect(@user.time_entries.size).to eq(1)
      time_entry = @user.time_entries.take
      expect(time_entry.distance).to eq(1200)
      expect(time_entry.time).to eq(200)
      expect(time_entry.date).to eq(date)
    end
  end
end
