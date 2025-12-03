class AddPlannedCostFromResourcesToSubTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_tasks, :planned_cost_from_resources, :decimal
  end
end
