class User < ApplicationRecord
  has_many :businesses, dependent: :destroy
  has_many :projects
  has_many :workers
  has_many :machines
  has_many :materials
  has_many :custom_resources
  has_many :real_activities
  has_many :norms

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  validates :terms, acceptance: true, on: :create

  after_initialize :set_default_locale, if: :new_record?
  after_commit :send_welcome_email, on: :create

  private

  def password_required?
    new_record? || password.present?
  end

  def set_default_locale
    self.locale ||= 'sr'
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
