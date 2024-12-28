class Business < ApplicationRecord
  belongs_to :user, optional: true # Opcionalna veza sa korisnikom
  has_many :projects
  has_many :workers
  has_many :machines

  validates :name, presence: true
end
