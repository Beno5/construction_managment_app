class CreateRealActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :real_activities do |t|
      t.references :activity, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.decimal :integer
      t.decimal :difference

      t.timestamps
    end
  end
end
