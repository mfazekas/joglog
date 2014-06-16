class TimeEntriesController < ApplicationController
  def index
    @time_entries = current_user.time_entries
  end

  def new
    @time_entry = current_user.time_entries.build
    @time_entry.date = DateTime.now
  end

  def create
    @time_entry = current_user.time_entries.build time_entries_param
    if @time_entry.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def search
    from = params[:from]
    to = params[:to]
    byebug
    @time_entries = current_user.time_entries.where(date:from_date..to_date)
    render :index
  end

  def weekly
    time_entries_rel = current_user.time_entries
    sums_by_week = time_entries_rel.select('sum(time_entries.distance) as total_distance,sum(time_entries.time) as total_time,time_entries.week').group(:week)
    @sums_by_week = sums_by_week.map {|s| {week: TimeEntry.week_info(s.week), average: s.total_distance/s.total_time,distance:s.total_distance}}
  end

  private
 
  def time_entries_param
    ret = params.require(:time_entry).permit(:time_in_minutes,:distance,date:[:time,:date])
  end
end