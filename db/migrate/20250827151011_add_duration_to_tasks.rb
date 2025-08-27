class AddDurationToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :duration, :decimal, precision: 10, scale: 2
  end
end
