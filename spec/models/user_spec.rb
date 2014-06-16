require 'rails_helper'

describe User, type: :model do
  describe "attributes" do
    before do
      @user = User.new
    end
    
    it {expect(@user).to respond_to(:first_name)}
    it {expect(@user).to respond_to(:last_name)}
    it {expect(@user).to respond_to(:email)}
  end
  
  describe "associations" do
    before do
      @user = User.new
    end
    
    it {expect(@user).to respond_to(:time_entries)}
    it {expect(@user).to respond_to(:authentications)}
  end

end