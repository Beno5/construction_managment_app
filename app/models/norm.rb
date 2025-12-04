class Norm < ApplicationRecord
  belongs_to :business
  belongs_to :user

  has_many :sub_task_norms, dependent: :destroy
  has_many :sub_tasks, through: :sub_task_norms

  enum :norm_type, { worker: 0, material: 1, machine: 2 }, allow_nil: true
  enum :subtype, { skilled: 0, unskilled: 1 }, allow_nil: true

  scope :for_business, ->(business_id) { where(business_id:) }

  validates :name, presence: true
end
