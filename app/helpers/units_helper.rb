module UnitsHelper
  def all_unit_options
    worker_units   = Worker.unit_of_measures.keys.map   { |k| [k.humanize, k] }
    material_units = Material.unit_of_measures.keys.map { |k| [k.humanize, k] }
    machine_units  = Machine.unit_of_measures.keys.map  { |k| [k.humanize, k] }

    (worker_units + material_units + machine_units).uniq { |_, v| v }
  end
end
