class Activity < ApplicationRecord
  belongs_to :task
  belongs_to :activityable, polymorphic: true

  enum :activity_type, { worker: 0, machine: 1 }
end
