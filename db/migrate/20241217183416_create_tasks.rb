class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.integer :quantity
      t.string :unit
      t.date :planned_start_date
      t.date :planned_end_date
      t.decimal :planned_cost
      t.jsonb :custom_fields
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
