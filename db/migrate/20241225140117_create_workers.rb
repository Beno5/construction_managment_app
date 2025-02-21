class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.string :first_name
      t.string :last_name
      t.string :profession
      t.text :description
      t.string :phone_number
      t.integer :unit_of_measure, default: 0, null: false
      t.decimal :price_per_unit, precision: 10, scale: 2
      t.boolean :is_team, default: false
      t.jsonb :custom_fields, default: {}
      t.references :user, null: false, foreign_key: true 


      t.timestamps
    end
  end
end
