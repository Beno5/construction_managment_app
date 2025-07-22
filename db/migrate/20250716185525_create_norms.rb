class CreateNorms < ActiveRecord::Migration[7.0]
  def change
    create_table :norms do |t|
      t.string :name, null: false
      t.text :description
      t.string :info
      t.integer :norm_type, null: false, default: 0
      t.integer :subtype
      t.string :unit_of_measure
      t.decimal :norm_value, precision: 10, scale: 4
      t.string :tags, array: true, default: []

      t.timestamps
    end
  end
end
