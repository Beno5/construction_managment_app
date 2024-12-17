class Task < ApplicationRecord
  belongs_to :project

  # Validacije
  validates :description, :quantity, :unit, :planned_start, :planned_end, :planned_cost, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :planned_cost, numericality: { greater_than_or_equal_to: 0 }

  # Validacija za datume
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return unless planned_start && planned_end && planned_end < planned_start

    errors.add(:planned_end, "ne može biti pre planiranog početka radova")
  end
end
