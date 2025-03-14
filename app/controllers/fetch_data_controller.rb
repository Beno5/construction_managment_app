class FetchDataController < ApplicationController
  protect_from_forgery except: [:unit_options, :resources, :resource_details, :get_activity_and_resource_infos,
                                :get_activity_and_real_activity_infos, :get_document, :check_activity]

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

  def get_activity_and_resource_infos
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

  def check_activity
    item_id = params[:item_id]
    item_type = params[:item_type].delete('"').constantize

    if [Business, Task, SubTask].include?(item_type)
      render json: { has_activities: false }
      return
    end

    item = item_type.find(item_id)
    activities = item.activities.includes(sub_task: { task: :project })

    if activities.exists?
      activity_details = activities.map do |activity|
        sub_task = activity.sub_task
        task = sub_task.task
        project = task.project
        {
          business_id: project.business.id,
          project_id: project.id,
          task_id: task.id,
          sub_task_id: sub_task.id,
          project_name: project.name,
          task_name: task.name,
          sub_task_name: sub_task.name
        }
      end

      render json: {
        has_activities: true,
        activity_details: activity_details
      }
    else
      render json: { has_activities: false }
    end
  end

  def get_activity_and_real_activity_infos
    activity = Activity.find(params[:activity_id])
    real_activity = RealActivity.find_by(id: params[:real_activity_id])

    render json: {
      name: activity.activityable.name,
      unit_of_measure: activity.activityable.unit_of_measure,
      price_per_unit: activity.activityable.price_per_unit,
      quantity: real_activity&.quantity,
      start_date: real_activity&.start_date,
      end_date: real_activity&.end_date,
      total_cost: real_activity&.total_cost
    }
  end
end
