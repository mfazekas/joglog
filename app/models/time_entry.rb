class TimeEntry < ActiveRecord::Base
  belongs_to :user
  
  validates_numericality_of :time, greater_than: 0 
  validates_numericality_of :distance, greater_than_or_equal_to: 0
  validates_presence_of :date
  before_save :fill_week

  def self.in_range(from,to)
    if from.nil? and to.nil?
      all
    elsif from.present? and to.present?
      where(date:(from..to))
    elsif from.present?
      where('date >= ?',from)
    else
      where('date <= ?', to)
    end
  end
  
  def self.sums_by_week
    select('sum(time_entries.distance) as total_distance,sum(time_entries.time) as total_time,time_entries.week').group(:week)
  end
  
  def weekly_average_speed
    raise NoMethodError.new('weekly_average_speed can be called only instances returned by sums_by_week') if total_distance.nil? 
    total_distance/total_time.to_f
  end
  
  def average_speed
    distance/time.to_f
  end

  def time_in_minutes
    time.nil? ? nil : time/60
  end

  def time_in_minutes=(value)
    self.time=(value.nil? ? nil : value.to_i*60)
  end
  
  def self.week_info(week)
    cwyear = week/53
    cweek = week%53+1
    {year: cwyear, week: cweek, start:DateTime.commercial(cwyear,cweek) ,end:(DateTime.commercial(cwyear,cweek)+6.days).end_of_day}
  end

  private

  def fill_week
    datetime = self.date.to_datetime
    self.week = datetime.cwyear*53+(datetime.cweek-1)
  end

end