class AddPlanningFieldsToSubTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_tasks, :duration, :integer
    add_column :sub_tasks, :num_workers_skilled, :integer
    add_column :sub_tasks, :num_workers_unskilled, :integer
    add_column :sub_tasks, :num_machines, :integer
  end
end
