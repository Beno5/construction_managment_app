class ChangeDurationToDecimalOnSubTasks < ActiveRecord::Migration[7.0]
  def change
    change_column :sub_tasks, :duration, :decimal, precision: 10, scale: 2
  end
end
