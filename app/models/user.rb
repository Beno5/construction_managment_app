class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validacija email-a
  validates :email, presence: true, uniqueness: true

  # Validacija lozinke
  validates :password, presence: true, length: { minimum: 6 }
  validates :terms, acceptance: true
end
        
