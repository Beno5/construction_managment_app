class Business < ApplicationRecord
  belongs_to :user, optional: true # Opcionalna veza sa korisnikom
  has_many :projects, dependent: :destroy
  has_many :workers, dependent: :destroy
  has_many :machines, dependent: :destroy
  has_many :materials, dependent: :destroy

  enum :currency, { euro: 0, dolar: 1, dinar: 2 }

  validates :currency, presence: true
  validates :name, presence: true

  def currency_symbol
    {
      "euro" => "€",
      "dolar" => "$",
      "dinar" => "RSD"
    }[currency] || currency
  end
end
