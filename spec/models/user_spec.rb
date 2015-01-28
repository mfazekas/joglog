require 'rails_helper'

describe User, type: :model do
  describe "attributes" do
    subject { User.new }

    it { is_expected.to respond_to(:first_name)}
    it { is_expected.to respond_to(:last_name)}
    it { is_expected.to respond_to(:email)}
  end
  
  describe "associations" do
    subject { User.new }

    it { is_expected.to respond_to(:time_entries)}
    it { is_expected.to respond_to(:authentications)}
  end

end