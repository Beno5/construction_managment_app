class SubTask < ApplicationRecord
  include CustomFields

  belongs_to :task
  belongs_to :user
  has_many :activities, dependent: :delete_all
  has_many :real_activities, dependent: :delete_all
  has_many :custom_resources, dependent: :delete_all
  has_many :documents, dependent: :delete_all

  has_many :sub_task_norms, dependent: :delete_all
  has_many :pinned_norms, through: :sub_task_norms, source: :norm

  # Validacije
  validates :name, presence: true

  # Validacija za datume
  validate :end_date_after_start_date

  before_create :assign_position
  after_destroy :reorder_sub_tasks
  after_destroy :trigger_update_service
  after_save :trigger_update_service

  scope :ordered_by_position, -> { order(:position) }

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
  scope :search, lambda { |query|
    return all unless query.present?

    where("name ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%")
  }

  def calculate_duration
    return unless planned_start_date.present? && planned_end_date.present?

    ((planned_end_date.year * 12) + planned_end_date.month) - ((planned_start_date.year * 12) + planned_start_date.month)
  end

  def show_position
    "#{task.position}.#{position}"
  end

  def name_with_position
    "#{show_position} #{name}"
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
    return unless planned_end_date.present? && planned_start_date.present? && planned_end_date < planned_start_date

    errors.add(:base, :invalid_dates)
  end

  def trigger_update_service
    UpdateDynamicAttributesService.new(self).update_all!
  end
end
