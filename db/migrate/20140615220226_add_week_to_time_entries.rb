class AddWeekToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :week, :integer
  end
end
