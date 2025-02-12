class AddQuantityToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities, :quantity, :integer
  end
end
