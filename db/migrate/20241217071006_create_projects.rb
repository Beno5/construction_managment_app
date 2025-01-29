class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :project_type
      t.string :address
      t.string :project_manager
      t.date :planned_start_date
      t.date :planned_end_date
      t.decimal :estimated_cost
      t.text :description
      t.jsonb :custom_fields, default: {}
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
