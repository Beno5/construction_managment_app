class CreateSubTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_tasks do |t|
      t.string :name
      t.string :description
      t.date :planned_start_date
      t.date :planned_end_date
      t.decimal :planned_cost
      t.date :real_start_date
      t.date :real_end_date
      t.decimal :real_cost
      t.jsonb :custom_fields, default: {}
      t.bigint :user_id, null: false
      t.decimal :progress, default: 0.0
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
