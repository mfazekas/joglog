class TimeEntriesController < ApplicationController
  def new
    @time_entry = current_user.time_entries.build
    @time_entry.date = DateTime.now
  end

  def create
    params = time_entries_param
    
    datetime_str = params[:date][:date]+" "+params[:date][:time]
    errors={}
    begin
      params[:date]=DateTime.strptime(datetime_str,'%m/%d/%Y %H:%M')
    rescue
      params.delete(:date)
      errors[:date]="unable to parse date"
    end 
    
    @time_entry = current_user.time_entries.build params
    
    respond_to do |format|
      if errors.empty? and @time_entry.save
        format.html { redirect_to action: :index }
        format.js { head :no_content }
      else
        if not errors.empty?
          @time_entry.valid?
          errors = @time_entry.errors.to_hash.merge(errors)
        else
          errors = @time_entry.errors.to_hash
        end
        format.html { render :new }
        format.json { render json: {errors: errors}, status: :unprocessable_entity} 
        format.js { render json: {errors: errors}, status: :unprocessable_entity } 
      end
    end
  end

  def index
    from,to = from_to_params
    @time_entries = current_user.time_entries.in_range(from,to)
    @time_entry = TimeEntry.new(user:current_user, date:DateTime.now)
    respond_to do |format|
      format.json { render json: @time_entries.to_json(json_opts) }
    end
  end

  def weekly
    from,to = from_to_params
    @time_entries = current_user.time_entries.in_range(from,to)
    sums_by_week = @time_entries.sums_by_week
    @sums_by_week = sums_by_week.map {|s| {week: TimeEntry.week_info(s.week), average: s.weekly_average_speed, distance:s.total_distance}}
  end

  private
  
  def from_to_params
    range=[params[:start],params[:end]]
    range.map! do |timestr|
      if not timestr.blank? 
        DateTime.strptime(timestr,'%m/%d/%Y')
      end
    end
    [range[0].try(:beginning_of_day),range[1].try(:end_of_day)]
  end
 
  def time_entries_param
    params.require(:time_entry).permit(:time_in_minutes,:distance,date:[:time,:date]) 
  end

  def json_opts
    {only: [:date,:time,:distance]}
  end
end