class CreateLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :links do |t|
      t.integer :source_id
      t.integer :target_id
      t.string :link_type

      t.timestamps
    end
  end
end
