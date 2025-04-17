class AddClientProjectIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :client_project_id, :string
  end
end
