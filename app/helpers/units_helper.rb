module UnitsHelper
  def all_unit_options
    worker_units   = Worker.unit_of_measures.keys.map   { |k| [k, I18n.t("activerecord.attributes.worker.unit_of_measures.#{k}")] }
    material_units = Material.unit_of_measures.keys.map { |k| [k, I18n.t("activerecord.attributes.material.unit_of_measures.#{k}")] }
    machine_units  = Machine.unit_of_measures.keys.map  { |k| [k, I18n.t("activerecord.attributes.machine.unit_of_measures.#{k}")] }

    (worker_units + material_units + machine_units).uniq { |k, _| k }
  end
end
