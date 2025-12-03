class AddPlannedCostFromResourcesToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :planned_cost_from_resources, :decimal
  end
end
