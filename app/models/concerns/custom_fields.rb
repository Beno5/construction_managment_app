module CustomFields
  extend ActiveSupport::Concern

  included do
    # Default JSONB za custom_fields
    before_save :initialize_custom_fields
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
end
