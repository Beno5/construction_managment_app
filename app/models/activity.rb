class Activity < ApplicationRecord
  belongs_to :sub_task
  belongs_to :activityable, polymorphic: true
  has_many :real_activities, dependent: :destroy

  enum :activity_type, { worker: 0, machine: 1, material: 2, custom: 3 }

  after_destroy :update_parent_sub_task
  after_save :update_parent_sub_task

  def self.search(query)
    if query.present?
      query_downcase = query.downcase
      activities = preload(:activityable).all
      activities.select do |activity|
        activity.activity_type.downcase.include?(query_downcase) ||
          activity.quantity.to_s.downcase.include?(query_downcase) ||
          activity.total_cost.to_s.downcase.include?(query_downcase) ||
          activity.activityable.name.downcase.include?(query_downcase) ||
          activity.activityable.description.downcase.include?(query_downcase) ||
          activity.activityable.unit_of_measure.downcase.include?(query_downcase) ||
          activity.activityable.price_per_unit.to_s.downcase.include?(query_downcase)
      end
    else
      all
    end
  end

  private

  def update_parent_sub_task
    UpdateDynamicAttributesService.new(sub_task).update_all!
  end
end
