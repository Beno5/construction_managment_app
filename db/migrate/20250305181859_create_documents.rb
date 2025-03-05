class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.text :description
      t.integer :category, default: 0
      t.references :project, null: true, foreign_key: true
      t.references :task, null: true, foreign_key: true
      t.references :sub_task, null: true, foreign_key: true
      t.timestamps
    end
  end
end
