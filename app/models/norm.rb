class Norm < ApplicationRecord
  has_many :sub_task_norms, dependent: :destroy
  has_many :sub_tasks, through: :sub_task_norms


  enum norm_type: {
    worker: 0,
    material: 1,
    machine: 2
  }

  enum subtype: {
    kv: 0,
    nkv: 1
  }, _prefix: true # ovo je opcionalno da izbjegnemo konflikt metoda ako bude trebalo

  validates :name, :norm_type, :unit_of_measure, :norm_value, presence: true
end
