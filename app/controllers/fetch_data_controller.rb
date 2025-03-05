class FetchDataController < ApplicationController
  protect_from_forgery except: [:unit_options, :resources, :resource_details, :get_activity, :get_document]

  def unit_options
    worker_units = Worker.unit_of_measures.keys.map { |k| [k.humanize, k] }
    material_units = Material.unit_of_measures.keys.map { |k| [k.humanize, k] }
    machine_units = Machine.unit_of_measures.keys.map { |k| [k.humanize, k] }

    all_units = (worker_units + material_units + machine_units).uniq { |_, v| v }

    render json: {
      worker: worker_units.to_h,
      material: material_units.to_h,
      machine: machine_units.to_h,
      custom: all_units.to_h
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

  def get_activity
    @resource = Activity.find(params[:id]) # ili neki drugi model

    render json: {
      activity_type: @resource.activity_type,
      quantity: @resource.quantity,
      start_date: @resource.start_date,
      end_date: @resource.end_date,
      total_cost: @resource.total_cost,
      activityable_type: @resource.activityable_type,
      activityable_id: @resource.activityable_id,
      # Dodajemo podatke iz povezanog modela
      resource_name: @resource.activityable.name,
      resoruce_description: @resource.activityable.description,
      resoruce_unit_of_measure: @resource.activityable.unit_of_measure,
      resoruce_price_per_unit: @resource.activityable.price_per_unit,
      resoruce_profession: @resource.activityable.try(:profession),
      resoruce_first_name: @resource.activityable.try(:first_name),
      resoruce_last_name: @resource.activityable.try(:last_name)
    }
  end

  def get_document
    @document = Document.find(params[:id])
    render json: {
      id: @document.id,
      name: @document.name,
      description: @document.description,
      category: @document.category,
      file: @document.file.attached? ? { filename: @document.file.filename.to_s } : nil
    }
  end
end
