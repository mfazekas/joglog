class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.references :user, index: true
      t.datetime :date
      t.integer :distance
      t.integer :time
    end
  end
end
