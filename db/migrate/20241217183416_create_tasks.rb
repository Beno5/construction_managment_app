class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :description
      t.date :planned_start_date
      t.date :planned_end_date
      t.decimal :planned_cost
      t.date :real_start_date
      t.date :real_end_date
      t.decimal :real_cost
      t.jsonb :custom_fields, default: {}

      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
