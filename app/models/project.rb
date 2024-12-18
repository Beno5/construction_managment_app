class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy

  require 'date'

  enum :status, { pending: 0, active: 1, completed: 2, canceled: 3 }

  # Validations
  validates :name, :project_type, :address, :project_manager, :planned_start_date, :planned_end_date, presence: true
  validates :estimated_cost, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true
  validate :end_date_after_start_date

  # Callbacks
  before_save :calculate_duration

  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?
  
    months = ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
    months
  end

  def earliest_start_date
    tasks.minimum(:planned_start_date)
  end
  
  def latest_end_date
    tasks.maximum(:planned_end_date)
  end
  

  private

  def end_date_after_start_date
    return unless planned_end_date.present? && planned_start_date.present? && planned_end_date < planned_start_date

    errors.add(:planned_end_date, "cannot be earlier than the start date")
  end

end
