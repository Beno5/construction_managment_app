class CustomResource < ApplicationRecord
  belongs_to :sub_task
  belongs_to :user
  has_many :activities, as: :activityable

  enum :category, { material: 0, worker: 1, machine: 2, other: 3 }

  validates :name, :quantity, :unit_of_measure, :price_per_unit, :total_cost, presence: true
end
