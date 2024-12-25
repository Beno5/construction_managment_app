class Business < ApplicationRecord
  belongs_to :user, optional: true # Opcionalna veza sa korisnikom
  has_many :projects
  has_many :workers

  validates :name, presence: true
end
