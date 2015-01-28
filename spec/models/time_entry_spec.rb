require 'rails_helper'

describe TimeEntry, type: :model do
  subject { TimeEntry.new }

  describe "attributes" do
    it { is_expected.to respond_to(:date)}
    it { is_expected.to respond_to(:distance)}
    it { is_expected.to respond_to(:time)}
    it { is_expected.to respond_to(:time_in_minutes)}
    it { is_expected.to respond_to(:week)}
  end

  describe "associations" do
    it { is_expected.to respond_to(:user)}
  end

  describe "validations" do
    subject { TimeEntry.new(distance:1000,time:1) }

    it { is_expected.not_to allow_value(0).for(:time) }
    it { is_expected.not_to allow_value(-1).for(:time) }

    it { is_expected.not_to allow_value(-1).for(:distance) }
    it { is_expected.not_to allow_value(nil).for(:date) }
  end

  describe "week" do
    subject { TimeEntry.new(distance:1000,time:360,date:DateTime.now) }

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

  describe "in_range" do
    let(:base_time) { DateTime.now }
    let(:time_entries) { (1..10).map { |i| TimeEntry.create date:base_time+i.days, time:20, distance:100 } }
    let(:base_scope) { TimeEntry.where(id:time_entries.map(&:id)) }
    subject { base_scope.in_range(from,to).to_a }

    context "when neither defined" do
      let(:from) { nil }
      let(:to) { nil }
      it { is_expected.to eq(base_scope.all.to_a) }
    end
    context "when both defined" do
      let(:from) { base_time + 2.days }
      let(:to) { base_time + 5.days }
      it { is_expected.to eq(base_scope.to_a.select {|i| i.date <= to and i.date >= from }) }
    end
    context "when only end defined" do
      let(:from) { nil }
      let(:to) { base_time + 5.days }
      it { is_expected.to eq(base_scope.to_a.select {|i| i.date <= to }) }
    end
    context "when only start defined" do
      let(:from) { base_time + 5.days }
      let(:to) { nil }
      it { is_expected.to eq(base_scope.to_a.select {|i| i.date >= from }) }
    end
  end

  describe "sums_by_week" do
    let(:base_time) { DateTime.commercial(2014,02,01) }
    let(:time_entries) { (0..13).map { |i| TimeEntry.create date:base_time+i.days, time:20, distance:100 } }
    let(:base_scope) { TimeEntry.where(id:time_entries.map(&:id)) }

    subject { base_scope.sums_by_week.map { |i| a = i.attributes; a.delete('id'); a } }
    it "should return sum and averages" do
      is_expected.to eq([{"total_distance"=>700, "total_time"=>140, "week"=>106743},
                         {"total_distance"=>700, "total_time"=>140, "week"=>106744}])
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

    it "sets time to nil when it is nil" do
      subject.time_in_minutes=nil
      expect(subject.time).to eq(nil)
    end

    it "calculates using int multiplication not string" do
      subject.time_in_minutes="60"
      expect(subject.time).to eq(3600)
    end
  end

  describe "average_speed" do
    let(:time_entry) { TimeEntry.new(distance: 1000, time: 10.seconds) }
    subject { time_entry.average_speed }
    it "return average speed" do
      is_expected.to be_within(0.1).of(100)
    end
  end
end