class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :name
      t.text :description
      t.decimal :price_per_unit, precision: 10, scale: 2
      t.integer :unit_of_measure, default: 0, null: false
      t.jsonb :custom_fields, default: {}
      t.references :business, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
