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

  scope :ordered_by_position, -> { all.sort_by { |t| t.position.to_s.split('.').map(&:to_i) } }
  
    def name_with_position
    "#{position} #{name}"
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
    return unless planned_end_date.present? && planned_start_date.present? && planned_end_date < planned_start_date

    errors.add(:base, :invalid_dates)
  end
end
