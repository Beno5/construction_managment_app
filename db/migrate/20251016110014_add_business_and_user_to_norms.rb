class AddBusinessAndUserToNorms < ActiveRecord::Migration[7.0]
  def change
    add_reference :norms, :business, foreign_key: true
    add_reference :norms, :user, foreign_key: true
  end
end
