class CreateWorkers < ActiveRecord::Migration[7.0]
  def change
    create_table :workers do |t|
      t.string :first_name
      t.string :last_name
      t.string :profession
      t.text :description
      t.date :hired_on
      t.decimal :salary
      t.decimal :hourly_rate
      t.integer :contract_hours_per_month
      t.string :phone_number
      t.jsonb :custom_fields, default: {}

      t.timestamps
    end
  end
end
