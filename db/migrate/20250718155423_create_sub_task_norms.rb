class CreateSubTaskNorms < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_task_norms do |t|
      t.references :sub_task, null: false, foreign_key: true
      t.references :norm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
