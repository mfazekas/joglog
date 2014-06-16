require 'rails_helper'

describe TimeEntry, type: :model do
  describe "attributes" do
    before do
      @time_entry = TimeEntry.new
    end
    
    it {expect(@time_entry).to respond_to(:date)}
    it {expect(@time_entry).to respond_to(:distance)}
    it {expect(@time_entry).to respond_to(:time)}
    it {expect(@time_entry).to respond_to(:time_in_minutes)}
    it {expect(@time_entry).to respond_to(:week)}
  end
  
  describe "associations" do
    before do
      @time_entry = TimeEntry.new
    end
    
    it {expect(@time_entry).to respond_to(:user)}
  end
  
  describe "validations" do
    subject { TimeEntry.new(distance:1000,time:1) }
    
    it { should_not allow_value(0).for(:time) }
    it { should_not allow_value(-1).for(:time) }
    
    it { should_not allow_value(-1).for(:distance) }
    it { should_not allow_value(nil).for(:date) }
  end

  describe "week" do
    subject { TimeEntry.new(distance:1000,time:360,date:DateTime.now)}
    
    it "should fill in week when savved" do
      subject.save
      expect(subject.week).not_to be_nil
    end
    
    it "should be increasing" do
      for d in 0..7
        subject.date = DateTime.now+d.days
        subject.save
        week=subject.week
        for i in 0..100
          subject.date = subject.date+7.days
          subject.save
          expect(subject.week).to be > week
          week=subject.week
        end
      end
    end
    
    describe "week_info" do
      it "should return first and last day of the week" do
        subject.save
        week_info = TimeEntry.week_info(subject.week)
        expect(week_info).to include({week:subject.date.cweek,year:subject.date.cwyear})
        expect(week_info[:start]..week_info[:end]).to cover(subject.date)
      end
      
      it "should be less than at end of weeks last day" do
        subject.date = DateTime.commercial(2014,3,7).end_of_day
        subject.save
        week_info = TimeEntry.week_info(subject.week)
        expect(week_info[:start]..week_info[:end]).to cover(subject.date,DateTime.commercial(2014,3,1).beginning_of_day)
      end
    end
  end

  describe "time_in_minutes" do
    subject { TimeEntry.new(distance:1000,time:360)}
    
    it { expect(subject.time_in_minutes).to eq(6)}
    it "can be set" do
      subject.time_in_minutes=30
      expect(subject.time).to eq(30*60)
      expect(subject.time_in_minutes).to eq(30)
    end
    
    it "should be nil for object with nil time" do
      subject.time=nil
      expect(subject.time_in_minutes).to eq(nil)
    end
    
    xit "should return validation errors for this too" do
      subject.time_in_minutes=nil
      subject.save
      expect(subject.errors.get(:time)).to eq(['is not a number'])
      expect(subject.errors.get(:time_in_minutes)).to eq(['is not a number'])
    end
    
    it "sets time to nil when it is nil" do
      subject.time_in_minutes=nil
      expect(subject.time).to eq(nil)
    end
  end
  
  describe "average_speed" do
    it "return average speed" do
      @time_entry=TimeEntry.new(distance: 1000, time: 10.seconds)
      expect(@time_entry.average_speed).to be_within(0.1).of(100)
    end
  end

end