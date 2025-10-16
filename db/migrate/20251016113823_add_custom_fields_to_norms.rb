class AddCustomFieldsToNorms < ActiveRecord::Migration[7.0]
  def change
    add_column :norms, :custom_fields, :jsonb, default: {}
  end
end
