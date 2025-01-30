class AddProgressToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :progress, :decimal, default: 0.0
  end
end
