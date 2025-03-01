class CreateCustomResources < ActiveRecord::Migration[7.0]
  def change
    create_table :custom_resources do |t|
      t.string :name
      t.integer :quantity
      t.string :unit_of_measure
      t.decimal :price_per_unit
      t.decimal :total_cost
      t.text :description
      t.integer :category
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
