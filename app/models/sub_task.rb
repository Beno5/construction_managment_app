class SubTask < ApplicationRecord
  belongs_to :task
  belongs_to :user
  has_many :activities, dependent: :destroy
  has_many :custom_resources, dependent: :destroy
  has_many :documents, dependent: :destroy

  enum :category, { preparatory_work: 0, structural_construction: 1, installation_and_craft: 2, finishing_work: 3 }

  # Validacije
  validates :name, :description, :planned_start_date, :planned_end_date, :planned_cost, presence: true
  validates :planned_cost, numericality: { greater_than_or_equal_to: 0 }

  # Validacija za datume
  validate :end_date_after_start_date

  after_save :update_total_costs
  after_save :update_dates


  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?

    ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
  end

  def update_total_costs
    self.update_columns(planned_cost: activities.sum(:total_cost), real_cost: activities.joins(:real_activities).sum('real_activities.cost'))
    task.update_total_costs
  end

  def update_dates
    earliest_activity_start_date = activities.minimum(:planned_start_date)
    latest_activity_end_date = activities.maximum(:planned_end_date)

    self.update_columns(planned_start_date: earliest_activity_start_date, planned_end_date: latest_activity_end_date)
    task.update_dates
  end

  private

  def end_date_after_start_date
    return if planned_start_date.blank? || planned_end_date.blank?

    self.planned_end_date = planned_start_date + planned_end_date.days if planned_end_date.is_a?(Integer)

    return unless planned_end_date < planned_start_date

    errors.add(:planned_end_date, "must be after start date")
  end
end
