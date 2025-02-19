class Business < ApplicationRecord
  belongs_to :user, optional: true # Opcionalna veza sa korisnikom
  has_many :projects
  has_many :workers
  has_many :machines
  has_many :materials

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
