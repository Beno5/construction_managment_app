class User < ApplicationRecord
  has_many :businesses, dependent: :destroy
  has_many :projects
  has_many :workers
  has_many :machines
  has_many :materials
  has_many :custom_resources
  has_many :real_activities
  has_many :norms

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :terms, acceptance: true

  # Default locale fallback
  after_initialize :set_default_locale, if: :new_record?

  # Send welcome email after signup
  after_commit :send_welcome_email, on: :create

  private

  def set_default_locale
    I18n.locale = :sr if I18n.locale.blank?
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
