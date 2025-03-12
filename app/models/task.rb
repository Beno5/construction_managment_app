class Task < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :sub_tasks, dependent: :destroy
  has_many :documents, dependent: :destroy

  enum :category, { preparatory_work: 0, structural_construction: 1, installation_and_craft: 2, finishing_work: 3 }

  # Validacije
  validates :name, :description, :planned_start_date, :planned_end_date, :planned_cost, presence: true
  validates :planned_cost, numericality: { greater_than_or_equal_to: 0 }

  # Validacija za datume
  validate :end_date_after_start_date




  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?

    ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
  end

  def update_total_costs
    self.update_columns(planned_cost: sub_tasks.sum(:planned_cost), real_cost: sub_tasks.sum(:real_cost))
    project.update_total_costs
  end

  def update_dates
    earliest_sub_tasks_start_date = sub_tasks.minimum(:planned_start_date)
    latest_sub_tasks_end_date = sub_tasks.maximum(:planned_end_date)

    self.update_columns(planned_start_date: earliest_sub_tasks_start_date, planned_end_date: latest_sub_tasks_end_date)
    project.update_dates
  end

  private

  def end_date_after_start_date
    return if planned_start_date.blank? || planned_end_date.blank?

    self.planned_end_date = planned_start_date + planned_end_date.days if planned_end_date.is_a?(Integer)

    return unless planned_end_date < planned_start_date

    errors.add(:planned_end_date, "must be after start date")
  end
end
