class User < ApplicationRecord
  has_many :businesses, dependent: :destroy
  has_many :projects
  has_many :workers
  has_many :machines
  has_many :materials
  has_many :custom_resources
  has_many :real_activities
  has_many :norms

  
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
        

