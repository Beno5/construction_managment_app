class AddWorkingHoursPerDayToBusinesses < ActiveRecord::Migration[7.0]
  def change
    add_column :businesses, :working_hours_per_day, :decimal, precision: 5, scale: 2, default: 9.0, null: false
  end
end
