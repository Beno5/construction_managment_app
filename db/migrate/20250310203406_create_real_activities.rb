class CreateRealActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :real_activities do |t|
      t.integer :quantity
      t.decimal :total_cost
      t.date :start_date
      t.date :end_date
      t.references :activity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :sub_task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
