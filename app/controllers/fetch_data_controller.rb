class FetchDataController < ApplicationController
  def unit_options
    worker_units = Worker.unit_of_measures.keys.map { |k| [k.humanize, k] }
    material_units = Material.unit_of_measures.keys.map { |k| [k.humanize, k] }
    machine_units = Machine.unit_of_measures.keys.map { |k| [k.humanize, k] }

    all_units = (worker_units + material_units + machine_units).uniq { |_, v| v }

    render json: {
      worker: worker_units.to_h,
      material: material_units.to_h,
      machine: machine_units.to_h,
      other: all_units.to_h
    }
  end

  def resources
    business = Business.find(params[:business_id])
    resources = case params[:category]
                when "worker"
                  business.workers.select(:id, :first_name, :last_name).map { |w| { id: w.id, name: w.name } }
                when "material"
                  business.materials.select(:id, :name)
                when "machine"
                  business.machines.select(:id, :name)
                else
                  []
                end

    render json: resources
  end

  def resource_details
    resource = case params[:category]
               when "worker"
                 Worker.find_by(id: params[:id])
               when "material"
                 Material.find_by(id: params[:id])
               when "machine"
                 Machine.find_by(id: params[:id])
               end

    if resource
      render json: {
        unit_of_measure: resource.unit_of_measure,
        price_per_unit: resource.price_per_unit,
        description: resource.description,
        profession: resource.is_a?(Worker) ? resource.profession : nil,
        fixed_costs: resource.is_a?(Machine) ? resource.fixed_costs : nil
      }
    else
      render json: { error: 'Resource not found' }, status: :not_found
    end
  end
end
