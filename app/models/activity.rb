class Activity < ApplicationRecord
  belongs_to :sub_task
  belongs_to :activityable, polymorphic: true

  enum :activity_type, { worker: 0, machine: 1, material: 2, custom: 3 }
end
