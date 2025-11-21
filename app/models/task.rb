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

  scope :ordered_by_position, -> { order(:position) }

  def name_with_position
    "#{position}. #{name}"
  end

  private

  def assign_position
    self.position = (project.tasks.maximum(:position) || 0) + 1
  end

  def end_date_after_start_date
    return unless planned_end_date.present? && planned_start_date.present? && planned_end_date < planned_start_date

    errors.add(:base, :invalid_dates)
  end
end
