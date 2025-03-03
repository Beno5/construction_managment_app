class CustomResource < ApplicationRecord
  belongs_to :sub_task
  belongs_to :user
  has_many :activities, as: :activityable

  enum :category, { material: 0, worker: 1, machine: 2, custom: 3 }

  validates :quantity, :unit_of_measure, :price_per_unit, :total_cost, presence: true

  def name
    if worker?
      "#{first_name} #{last_name}".strip.presence
    elsif self[:name].present?
      super
    end
  end
end
