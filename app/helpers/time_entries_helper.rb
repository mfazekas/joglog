module TimeEntriesHelper
  def number_to_human_speed(speed_in_m_per_s)
    speed_in_km_h = speed_in_m_per_s*3.6
    number_to_human(speed_in_km_h)+" km/h"
  end

  def time_as_minutes(seconds)
    seconds.nil? ? nil : seconds/60
  end

  def mintes_as_time(minutes)
    mintues.nil? ? nil : minutes*60
  end  
end
