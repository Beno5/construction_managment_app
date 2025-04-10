class AddAutoCalculationToSubTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_tasks, :planned_auto_calculation, :boolean, default: true
    add_column :sub_tasks, :real_auto_calculation, :boolean, default: true
  end
end
