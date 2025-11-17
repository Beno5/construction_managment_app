class AddUniqueIndexToBusinessesName < ActiveRecord::Migration[7.0]
  def change
    # Remove old single-column index on user_id
    remove_index :businesses, :user_id, if_exists: true

    # Add unique compound index on [user_id, name]
    # This enforces uniqueness at the database level and improves query performance
    add_index :businesses, [:user_id, :name], unique: true, name: 'index_businesses_on_user_id_and_name'
  end
end
