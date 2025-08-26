class ChangeWorkersAndMachinesToDecimalOnSubTasks < ActiveRecord::Migration[7.0]
  def change
    change_column :sub_tasks, :num_workers_skilled, :decimal, precision: 10, scale: 2
    change_column :sub_tasks, :num_workers_unskilled, :decimal, precision: 10, scale: 2
    change_column :sub_tasks, :num_machines, :decimal, precision: 10, scale: 2
  end
end
