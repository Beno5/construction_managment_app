module ApplicationHelper
  def t_enum(record, enum_attr)
    return "-" if record.send(enum_attr).blank?

    # Pluralize enum_attr for I18n lookup (unit_of_measure -> unit_of_measures)
    I18n.t("activerecord.attributes.#{record.model_name.i18n_key}.#{enum_attr.to_s.pluralize}.#{record.send(enum_attr)}")
  end
end
