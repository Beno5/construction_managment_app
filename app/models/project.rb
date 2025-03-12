class Project < ApplicationRecord
  include CustomFields

  belongs_to :business
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :documents, dependent: :destroy

  require 'date'

  enum :status, { pending: 0, active: 1, completed: 2, canceled: 3, paused: 4 }

  # Validations
  validates :name, :address, :project_manager, :planned_start_date, :planned_end_date, presence: true
  validates :real_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true
  validate :end_date_after_start_date

  # Callbacks
  before_save :calculate_duration

  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?

    ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
  end

  def earliest_start_date
    tasks.minimum(:planned_start_date)
  end

  def latest_end_date
    tasks.maximum(:planned_end_date)
  end
 
  def update_total_costs
    self.update_columns(planned_cost: tasks.sum(:planned_cost), real_cost: tasks.sum(:real_cost))
  end

  def update_dates
    earliest_tasks_start_date = tasks.minimum(:planned_start_date)
    latest_tasks_end_date = tasks.maximum(:planned_end_date)

    self.update_columns(planned_start_date: earliest_tasks_start_date, planned_end_date: latest_tasks_end_date)
  end

  private

  def end_date_after_start_date
    return unless planned_end_date.present? && planned_start_date.present? && planned_end_date < planned_start_date

    errors.add(:planned_end_date, "cannot be earlier than the start date")
  end
end
