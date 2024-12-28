class Machine < ApplicationRecord
  belongs_to :business

  # Validations
  validates :name, presence: true

  # Scopes
  scope :available, -> { where(is_occupied: false) }
  scope :occupied, -> { where(is_occupied: true) }

  # Methods
  def toggle_occupation!
    update(is_occupied: !is_occupied)
  end
end
