module CustomFields
  extend ActiveSupport::Concern

  included do
    before_save :initialize_custom_fields
    before_save :sanitize_custom_fields
  end

  # Postavljanje custom field-a
  def set_custom_field(key, value)
    custom_fields[key] = value
    save
  end

  # Dohvatanje custom field-a
  def get_custom_field(key)
    custom_fields[key]
  end

  # Brisanje custom field-a
  def remove_custom_field(key)
    custom_fields.delete(key)
    save
  end

  # Listanje svih custom field-ova
  def list_custom_fields
    custom_fields
  end

  private

  # Inicijalizacija default vrednosti za custom_fields ako su prazni
  def initialize_custom_fields
    self.custom_fields ||= {}
  end

  # Sanitacija custom_fields: uklanjanje praznih vrijednosti
  def sanitize_custom_fields
    self.custom_fields = custom_fields.reject { |_, v| v.blank? }
  end
end
