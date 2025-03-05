class Document < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :task, optional: true
  belongs_to :sub_task, optional: true

  has_one_attached :file

  enum :category, { nothing: 0, plan: 1, report: 2, doc_order: 3, offer: 4, other: 5 }, default: :nothing

  validates :name, presence: true
  validate :must_belong_to_at_least_one

  private

  def must_belong_to_at_least_one
    return if project_id.present? || task_id.present? || sub_task_id.present?

    errors.add(:base, "Document must belong to at least one of Project, Task, or SubTask")
  end
end
