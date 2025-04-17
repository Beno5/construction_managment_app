class AddPositionToSubtasks < ActiveRecord::Migration[7.0]
  def change
    add_column :sub_tasks, :position, :integer
  end
end
