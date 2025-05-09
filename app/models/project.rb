class Project < ApplicationRecord
  include CustomFields

  belongs_to :business
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :documents, dependent: :destroy

  require 'date'

  enum :status, { pending: 0, active: 1, completed: 2, canceled: 3, paused: 4 }

  # Validations
  validates :address, presence: true
  validates :real_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :client_project_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
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

  private

  def end_date_after_start_date
    return unless planned_end_date.present? && planned_start_date.present? && planned_end_date < planned_start_date

    errors.add(:planned_end_date, "cannot be earlier than the start date")
  end
end
