class AddAverageDailyHoursToWorkersAndMachines < ActiveRecord::Migration[7.0]
  def change
    add_column :workers, :average_daily_hours, :float
    add_column :machines, :average_daily_hours, :float
  end
end
