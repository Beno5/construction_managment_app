class Material < ApplicationRecord
  belongs_to :business
  has_many :activities, as: :activityable

  # Validations
  validates :name, :price_per_unit, :unit_of_measure, presence: true
  validates :price_per_unit, numericality: { greater_than: 0 }

  # Scopes
  scope :cheaper_than, ->(price) { where("price_per_unit < ?", price) }
  scope :by_unit, ->(unit) { where(unit_of_measure: unit) }

  # Za custom fields ćeš koristiti isti JSONB pristup
end