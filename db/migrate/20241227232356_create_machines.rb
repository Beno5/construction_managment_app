class CreateMachines < ActiveRecord::Migration[7.0]
  def change
    create_table :machines do |t|
      t.string :name
      t.string :category
      t.string :machine_type
      t.text :description
      t.boolean :is_occupied
      t.jsonb :custom_fields, default: {}
      t.references :business, null: false, foreign_key: true

      t.timestamps
    end
  end
end
