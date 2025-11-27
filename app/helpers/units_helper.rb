module UnitsHelper
  def all_unit_options
    worker_units = Worker.unit_of_measures.keys.map do |k|
      [k, I18n.t("activerecord.attributes.worker.unit_of_measures.#{k}")]
    end
    material_units = Material.unit_of_measures.keys.map do |k|
      [k, I18n.t("activerecord.attributes.material.unit_of_measures.#{k}")]
    end
    machine_units = Machine.unit_of_measures.keys.map do |k|
      [k, I18n.t("activerecord.attributes.machine.unit_of_measures.#{k}")]
    end

    (worker_units + material_units + machine_units).uniq { |k, _| k }
  end

  def translate_unit(unit_key)
    return "-" if unit_key.blank?

    # Try to find translation in worker, material, or machine unit_of_measures
    [:worker, :material, :machine].each do |model|
      translation_key = "activerecord.attributes.#{model}.unit_of_measures.#{unit_key}"
      return I18n.t(translation_key) if I18n.exists?(translation_key)
    end

    # If no translation found, return the key as fallback
    unit_key
  end
end
