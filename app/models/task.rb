class Task < ApplicationRecord
  include CustomFields

  belongs_to :project
  belongs_to :user
  has_many :sub_tasks, dependent: :delete_all
  has_many :documents, dependent: :delete_all

  # Validacije
  validates :name, presence: true
  validate :end_date_after_start_date

  before_create :assign_position
  after_destroy :reorder_tasks
  after_destroy :trigger_update_service
  after_save :trigger_update_service

  enum :unit_of_measure, {
    m: 0, m2: 1, m3: 2, kg: 3, ton: 4, pieces: 5, liters: 6,
    roll: 7, bag: 8, set: 9, hours: 10, pauschal: 11
  }

  scope :ordered_by_position, -> { order(:position) }

  scope :search, lambda { |query|
    return all unless query.present?

    searchable_task_columns = column_names - %w[created_at updated_at]
    searchable_sub_task_columns = SubTask.column_names - %w[created_at updated_at task_id]

    task_conditions = searchable_task_columns.map do |column|
      "unaccent(tasks.#{column}::text) ILIKE unaccent(:q)"
    end
    sub_task_conditions = searchable_sub_task_columns.map do |column|
      "unaccent(sub_tasks.#{column}::text) ILIKE unaccent(:q)"
    end

    all_conditions = (task_conditions + sub_task_conditions).join(" OR ")

    left_outer_joins(:sub_tasks)
      .where(all_conditions, q: "%#{query}%")
      .distinct
  }

  def name_with_position
    "#{position}. #{name}"
  end

  # Check if this task itself matches the search query (not just its subtasks)
  def matches_search?(query)
    return true if query.blank?

    searchable_columns = self.class.column_names - %w[created_at updated_at]

    searchable_columns.any? do |column|
      value = send(column)
      next false if value.nil?

      # Use unaccent and case-insensitive comparison like the scope
      normalized_value = value.to_s.downcase
      normalized_query = query.to_s.downcase
      normalized_value.include?(normalized_query)
    end
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
