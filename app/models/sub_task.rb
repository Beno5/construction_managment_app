class SubTask < ApplicationRecord
  include CustomFields

  belongs_to :task
  belongs_to :user
  has_many :activities, dependent: :destroy
  has_many :real_activities, dependent: :destroy
  has_many :custom_resources, dependent: :destroy
  has_many :documents, dependent: :destroy

  has_many :sub_task_norms, dependent: :destroy
  has_many :pinned_norms, through: :sub_task_norms, source: :norm

  # Validacije
  validates :name, presence: true

  # Validacija za datume
  validate :end_date_after_start_date

  before_create :assign_position
  after_destroy :trigger_update_service
  after_destroy :reorder_sub_tasks
  after_save :trigger_update_service

  enum :unit_of_measure, { kg: 0, m2: 1, m3: 2, pieces: 3, ton: 4, liters: 5, roll: 6, bag: 7, set: 8 }

  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?

    ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
  end

  def show_position
    "#{task.position}.#{position}"
  end

  private

  def assign_position
    self.position = task.sub_tasks.maximum(:position).to_i + 1
  end

  def reorder_sub_tasks
    task.sub_tasks.order(:position).each_with_index do |sub_task, index|
      sub_task.update(position: index + 1)
    end
  end

  def end_date_after_start_date
    return if planned_start_date.blank? || planned_end_date.blank?

    self.planned_end_date = planned_start_date + planned_end_date.days if planned_end_date.is_a?(Integer)

    return unless planned_end_date < planned_start_date

    errors.add(:planned_end_date, "must be after start date")
  end

  def trigger_update_service
    UpdateDynamicAttributesService.new(self).update_all!
  end
end
