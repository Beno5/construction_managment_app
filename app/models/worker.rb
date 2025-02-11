class Worker < ApplicationRecord
  include CustomFields
  belongs_to :business
  has_many :activities, as: :activityable

  # Validations
  validates :first_name, :last_name, :profession, presence: true

  # Helper method
  def full_name
    "#{first_name} #{last_name}"
  end
end
