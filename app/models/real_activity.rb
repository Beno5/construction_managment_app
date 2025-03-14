class RealActivity < ApplicationRecord
  belongs_to :activity
  belongs_to :user
  belongs_to :sub_task

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_destroy :update_parent_sub_task
  after_save :update_parent_sub_task

  private

  def update_parent_sub_task
    UpdateDynamicAttributesService.new(sub_task).update_all!
  end
end
