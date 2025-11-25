class Task < ApplicationRecord
  include CustomFields

  belongs_to :project
  belongs_to :user
  has_many :sub_tasks, dependent: :delete_all
  has_many :documents, dependent: :delete_all

  # Validacije
  validates :name, presence: true

  # Validacija za datume
  validate :end_date_after_start_date

  before_create :assign_position
  after_destroy :reorder_tasks
  after_destroy :trigger_update_service
  after_save :trigger_update_service

  enum :unit_of_measure, {
    m: 0,
    m2: 1,
    m3: 2,
    kg: 3,
    ton: 4,
    pieces: 5,
    liters: 6,
    roll: 7,
    bag: 8,
    set: 9,
    hours: 10,
    pauschal: 11
  }

  scope :ordered_by_position, -> { all.sort_by { |t| t.position.to_s.split('.').map(&:to_i) } }

  def name_with_position
    "#{position}. #{name}"
  end

  private

  def assign_position
    self.position = (project.tasks.maximum(:position) || 0) + 1
  end

  def reorder_tasks
    project.tasks.order(:position).each_with_index do |task, index|
      task.update_columns(position: index + 1)
    end
  end

  def end_date_after_start_date
    return unless planned_end_date.present? && planned_start_date.present? && planned_end_date < planned_start_date

    errors.add(:base, :invalid_dates)
  end

  def trigger_update_service
    UpdateDynamicAttributesService.new(self).update_all!
  end
end
