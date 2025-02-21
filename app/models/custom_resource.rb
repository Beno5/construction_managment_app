class CustomResource < ApplicationRecord
  belongs_to :task

  enum category: { material: 0, worker: 1, machine: 2 }

  validates :name, :quantity, :unit_of_measure, :price_per_unit, :total_cost, presence: true
end
