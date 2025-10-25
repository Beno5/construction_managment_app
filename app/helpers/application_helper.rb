module ApplicationHelper
  def t_enum(record, enum_attr)
    return "-" if record.send(enum_attr).blank?

    I18n.t("activerecord.attributes.#{record.model_name.i18n_key}.#{enum_attr}.#{record.send(enum_attr)}")
  end
end
