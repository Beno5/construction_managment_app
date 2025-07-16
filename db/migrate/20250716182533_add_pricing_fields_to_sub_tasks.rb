class AddPricingFieldsToSubTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_tasks, :price_per_unit, :decimal, precision: 10, scale: 2
    add_column :sub_tasks, :unit_of_measure, :integer, default: 0
    add_column :sub_tasks, :quantity, :integer
    add_column :sub_tasks, :total_cost, :decimal
  end
end
