module UnitsHelper
  def all_unit_options
    worker_units   = Worker.unit_of_measures.keys.map   { |k| [I18n.t("activerecord.attributes.worker.unit_of_measures.#{k}"), k] }
    material_units = Material.unit_of_measures.keys.map { |k| [I18n.t("activerecord.attributes.material.unit_of_measures.#{k}"), k] }
    machine_units  = Machine.unit_of_measures.keys.map  { |k| [I18n.t("activerecord.attributes.machine.unit_of_measures.#{k}"), k] }

    (worker_units + material_units + machine_units).uniq { |_, v| v }
  end
end
