class Task < ApplicationRecord
  belongs_to :project

  # Validacije
  validates :description, :quantity, :unit, :planned_start_date, :planned_end_date, :planned_cost, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :planned_cost, numericality: { greater_than_or_equal_to: 0 }

  # Validacija za datume
  validate :end_date_after_start_date

  def earliest_start_date
    tasks.minimum(:planned_start_date)
  end

  def latest_end_date
    tasks.maximum(:planned_end_date)
  end

  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?

    ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
  end

  private

  def end_date_after_start_date
    return if planned_start_date.blank? || planned_end_date.blank?
  
    if planned_end_date.is_a?(Integer)
      self.planned_end_date = planned_start_date + planned_end_date.days
    end
  
    if planned_end_date < planned_start_date
      errors.add(:planned_end_date, "must be after start date")
    end
  end
end
