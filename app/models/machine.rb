class Machine < ApplicationRecord
  belongs_to :business
  belongs_to :user

  has_many :activities, as: :activityable

  enum :unit_of_measure, { hourly: 0, daily: 1, weekly: 2, monthly: 3, per_task: 4 }

  # Validations
  validates :name, presence: true
end
