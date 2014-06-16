class TimeEntry < ActiveRecord::Base
  belongs_to :user
  
  validates_numericality_of :time, greater_than: 0 
  validates_numericality_of :distance, greater_than_or_equal_to: 0
  validates_presence_of :date
  before_save :fill_week
  
  def human_attribute_name(param)
    if param=:time_in_minutes then
      param=:time
    end
    return super(parm)
  end
  
  def average_speed
    distance/time.to_f
  end

  def time_in_minutes
    time.nil? ? nil : time/60
  end

  def time_in_minutes=(value)
    self.time=(value.nil? ? nil : value*60)
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