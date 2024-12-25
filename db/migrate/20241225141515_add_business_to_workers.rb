class AddBusinessToWorkers < ActiveRecord::Migration[7.0]
  def change
    add_reference :workers, :business, null: false, foreign_key: true
  end
end
