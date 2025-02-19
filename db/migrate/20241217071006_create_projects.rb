class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :project_manager
      t.date :planned_start_date
      t.date :planned_end_date
      t.decimal :planned_cost
      t.date :real_start_date
      t.date :real_end_date
      t.decimal :real_cost
      t.integer :status, default: 0
      t.jsonb :custom_fields, default: {}
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
