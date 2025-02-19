class Worker < ApplicationRecord
  include CustomFields

  belongs_to :business
  has_many :activities, as: :activityable

  # Enum za jedinicu vremena
  enum :unit_of_measure, { hourly: 0, daily: 1, weekly: 2, monthly: 3, per_task: 4 }

  # Validations
  validates :first_name, :last_name, :profession, presence: true
  validates :price_per_unit, numericality: { greater_than_or_equal_to: 0 }

  # Helper method
  def full_name
    "#{first_name} #{last_name}"
  end
end
