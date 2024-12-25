class AddBusinessToProjects < ActiveRecord::Migration[7.0]
  def change
    add_reference :projects, :business, null: false, foreign_key: true
  end
end
