class CreateActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :activities do |t|
      t.integer :activity_type
      t.integer :quantity
      t.date :start_date
      t.date :end_date
      t.decimal :total_cost
      t.bigint :sub_task_id
      t.bigint :activityable_id
      t.string :activityable_type

      t.timestamps
    end
  end
end
