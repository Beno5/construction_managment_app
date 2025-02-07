class Link < ApplicationRecord
  belongs_to :source, class_name: "Task"
  belongs_to :target, class_name: "Task"

  validates :source_id, :target_id, :link_type, presence: true
end
