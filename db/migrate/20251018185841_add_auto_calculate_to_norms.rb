class AddAutoCalculateToNorms < ActiveRecord::Migration[7.0]
  def change
    add_column :norms, :auto_calculate, :boolean, default: false
  end
end
