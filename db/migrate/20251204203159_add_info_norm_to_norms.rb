class AddInfoNormToNorms < ActiveRecord::Migration[7.0]
  def change
    add_column :norms, :info_norm, :boolean, default: false
  end
end
