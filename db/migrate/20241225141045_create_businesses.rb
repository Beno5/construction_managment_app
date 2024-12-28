class CreateBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.jsonb :custom_fields, default: {}

      t.timestamps
    end
  end
end
