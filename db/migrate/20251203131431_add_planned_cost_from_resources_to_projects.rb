class AddPlannedCostFromResourcesToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :planned_cost_from_resources, :decimal
  end
end
