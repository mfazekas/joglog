require 'rails_helper'

RSpec.describe "TimeEntries", type: :request do
  describe "GET /time_entries" do
    it "works!" do
      log_in
      get time_entries_path
      expect(response.status).to be(200)
      expect(response.body).to include("<title>JoggingTimes</title>")
    end
  end
end
