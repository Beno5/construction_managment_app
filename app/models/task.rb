class Task < ApplicationRecord
  include CustomFields

  belongs_to :project
  belongs_to :user
  has_many :sub_tasks, dependent: :destroy
  has_many :documents, dependent: :destroy

  # Validacije
  validates :name, presence: true

  # Validacija za datume
  validate :end_date_after_start_date

  before_create :assign_position
  after_destroy :reorder_tasks

  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?

    ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
  end

  private

  def assign_position
    self.position = (project.tasks.maximum(:position) || 0) + 1
  end

  def reorder_tasks
    project.tasks.order(:position).each_with_index do |task, index|
      task.update(position: index + 1)
    end
  end

  def end_date_after_start_date
    return if planned_start_date.blank? || planned_end_date.blank?

    self.planned_end_date = planned_start_date + planned_end_date.days if planned_end_date.is_a?(Integer)

    return unless planned_end_date < planned_start_date

    errors.add(:planned_end_date, "must be after start date")
  end
end
