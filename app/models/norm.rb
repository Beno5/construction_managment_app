class Norm < ApplicationRecord
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
