class Business < ApplicationRecord
  belongs_to :user, optional: true # Opcionalna veza sa korisnikom
  has_many :projects, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_many :machines, dependent: :destroy
  has_many :materials, dependent: :destroy
  has_many :norms, dependent: :destroy

  enum :currency, { euro: 0, dolar: 1, dinar: 2 }

  validates :name, presence: true, uniqueness: { scope: :user_id, message: :taken_for_user }
  validates :working_hours_per_day,
            presence: true,
            numericality: { greater_than: 0, less_than_or_equal_to: 24 }

  def working_hours_per_day_or_default
    working_hours_per_day.presence || 9.0
  end

  def currency_symbol
    {
      "euro" => "€",
      "dolar" => "$",
      "dinar" => "RSD"
    }[currency] || currency
  end
end
