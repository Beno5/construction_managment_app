class Material < ApplicationRecord
  belongs_to :business
  belongs_to :user

  has_many :activities, as: :activityable

  # Validations
  validates :name, presence: true
  enum :unit_of_measure, {
    kg: 0,
    m2: 1,
    m3: 2,
    pieces: 3,
    ton: 4,
    liters: 5,
    roll: 6,
    bag: 7,
    set: 8,
    pauschal: 9
  }
end
