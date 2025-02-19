class CreateBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :vat_number
      t.string :registration_number
      t.string :owner_first_name
      t.string :owner_last_name
      t.jsonb :custom_fields, default: {}
      t.integer :currency, default: "euro"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
