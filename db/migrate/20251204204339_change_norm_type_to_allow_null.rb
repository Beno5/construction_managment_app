class ChangeNormTypeToAllowNull < ActiveRecord::Migration[7.0]
  def change
    change_column_default :norms, :norm_type, from: 0, to: nil
    change_column_null :norms, :norm_type, true
  end
end
