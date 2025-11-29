class AddUnitQuantityPriceToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :unit_of_measure, :integer, default: 0
    add_column :tasks, :quantity, :integer
    add_column :tasks, :price_per_unit, :decimal, precision: 10, scale: 2
  end
end
