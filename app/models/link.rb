class Link < ApplicationRecord
  belongs_to :source, class_name: "Task"
  belongs_to :target, class_name: "Task"

  validates :source_id, presence: true
  validates :target_id, presence: true
  validates :link_type, presence: true
end
