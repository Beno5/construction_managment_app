class Worker < ApplicationRecord
  include CustomFields

  belongs_to :business
  belongs_to :user
  has_many :activities, as: :activityable

  # Enum za jedinicu vremena
  enum :unit_of_measure, { hourly: 0, daily: 1, weekly: 2, monthly: 3, per_task: 4 }

  # Validations
  validates :first_name, presence: true

  # Helper method
  def name
    "#{first_name} #{last_name}"
  end
end
