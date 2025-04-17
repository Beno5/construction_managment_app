class AddStartAndEndDateToCustomResources < ActiveRecord::Migration[7.0]
  def change
    add_column :custom_resources, :start_date, :date
    add_column :custom_resources, :end_date, :date
  end
end
