class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :description
      t.integer :quantity
      t.string :unit
      t.date :planned_start
      t.date :planned_end
      t.string :duration
      t.decimal :planned_cost
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end