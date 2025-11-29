module ApplicationHelper
  def t_enum(record, enum_attr)
    return "-" if record.send(enum_attr).blank?

    # Pluralize enum_attr for I18n lookup (unit_of_measure -> unit_of_measures)
    I18n.t("activerecord.attributes.#{record.model_name.i18n_key}.#{enum_attr.to_s.pluralize}.#{record.send(enum_attr)}")
  end

  def document_filename_display(document)
    if document.file.attached?
      content_tag(:span, class: "flex items-center gap-3") do
        concat(content_tag(:svg, class: "w-6 h-6 text-blue-600 dark:text-blue-400 flex-shrink-0", fill: "currentColor",
                                 viewBox: "0 0 20 20", xmlns: "http://www.w3.org/2000/svg") do
          content_tag(:path, nil,
                      d: "M5.5 13a3.5 3.5 0 01-.369-6.98 4 4 0 117.753-1.977A4.5 4.5 0 1113.5 13H11V9.413l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 001.414 1.414L9 9.414V13H5.5z")
        end) +
          content_tag(:span, document.file.filename.to_s, class: "truncate max-w-[250px] font-medium")
      end
    else
      content_tag(:span, class: "flex items-center gap-3 text-gray-400") do
        concat(content_tag(:svg, class: "w-6 h-6 flex-shrink-0", fill: "currentColor", viewBox: "0 0 20 20",
                                 xmlns: "http://www.w3.org/2000/svg") do
          content_tag(:path, nil,
                      d: "M5.5 13a3.5 3.5 0 01-.369-6.98 4 4 0 117.753-1.977A4.5 4.5 0 1113.5 13H11V9.413l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 001.414 1.414L9 9.414V13H5.5z")
        end) +
          content_tag(:span, t('documents.form.no_file'), class: "font-medium")
      end
    end
  end

  def document_category_label(document)
    key = document.category.presence || "nothing"
    I18n.t("activerecord.attributes.document.categories.#{key}", default: key.to_s.humanize)
  end
end
