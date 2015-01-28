require 'rails_helper'

RSpec.describe "TimeEntries", type: :api do
  let(:uid) { "1234" }
  let(:logged_in_uid) { log_in uid:uid ; uid }
  let!(:user) { get_user_for_uid(logged_in_uid) }
  let(:date) { DateTime.now.beginning_of_minute.in_time_zone }
  let(:data_as_json) { JSON.parse([date].to_json)[0] }

  describe "GET /time_entries" do
    subject { get "/time_entries", format: :json }

    context "with no entries" do
      it "returns and empty list" do
        subject

        expect(response.status).to be(200)
        expect(json).to eq([])
      end
    end

    context "with one entry" do
      let!(:time_entry) { user.time_entries.create date:date, time:20.seconds, distance:100 }
      it "returns it" do
        subject

        expect(response.status).to be(200)
        expect(json).to eq([{'date'=>data_as_json, "time"=>20, "distance"=>100}])
      end
    end
  end

  describe "POST /time_entires" do
    subject { post "/time_entries", time_entry:{ distance:1200, time:200, date:date.iso8601()}, format: :json }
    it "adds a new time entry" do
      subject

      expect(response.status).to be(200)
      expect(user.time_entries.size).to eq(1)
      time_entry = user.time_entries.take
      expect(time_entry.distance).to eq(1200)
      expect(time_entry.time).to eq(200)
      expect(time_entry.date).to eq(date)
    end
  end
end
