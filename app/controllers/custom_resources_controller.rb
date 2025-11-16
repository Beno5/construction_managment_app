class CustomResourcesController < ApplicationController
  before_action :set_sub_task
  before_action :set_custom_resource, only: [:edit, :update, :destroy]

  def new
    @custom_resource = @sub_task.custom_resources.build
  end

  def edit; end

  def create
    if params[:custom_resource][:activity_id].present? && params[:custom_resource][:activity_id] != "undefined"
      # UPDATE existing activity
      @activity = Activity.find(params[:custom_resource][:activity_id])
      custom_resource = @activity.activityable

      if custom_resource.update(custom_resource_params)
        @activity.update(quantity: custom_resource_params[:quantity], total_cost: custom_resource_params[:total_cost])
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    notice: t('activities.messages.updated')
      else
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    alert: custom_resource.errors.full_messages.join(', ')
      end
    else
      # CREATE new custom resource AND activity
      custom_resource = @sub_task.custom_resources.build(custom_resource_params)
      custom_resource.user = current_user # ✅ DODAJ current_user!

      if custom_resource.save
        @activity = @sub_task.activities.create!(
          activity_type: custom_resource_params[:category],
          start_date: custom_resource_params[:start_date],
          end_date: custom_resource_params[:end_date],
          activityable: custom_resource,
          quantity: custom_resource_params[:quantity],
          total_cost: custom_resource_params[:total_cost]
        )

        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    notice: t('activities.messages.created', name: custom_resource.name)
      else
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    alert: custom_resource.errors.full_messages.join(', ')
      end
    end
  end

  def update
    @activity = @sub_task.activities.find(params[:custom_resource][:activity_id])

    if @activity.update(params_mapped)
      redirect_to project_task_sub_task_path(@sub_task.task.project, @sub_task.task, @sub_task),
                  notice: t('activities.messages.updated', name: @activity.activityable.name)
    else
      flash.now[:alert] = t('activities.messages.update_error')
      render :edit
    end
  end

  def destroy
    name = @activity.activityable.name
    @activity.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    notice: t('activities.messages.deleted', name: name)
      end
    end
  end

  private

  def set_sub_task
    @sub_task = SubTask.find(params[:sub_task_id])
  end

  def set_custom_resource
    @custom_resource = @sub_task.custom_resources.find(params[:id])
  end

  def custom_resource_params
    params.require(:custom_resource).permit(
      :name,
      :first_name,
      :last_name,
      :quantity,
      :unit_of_measure,
      :price_per_unit,
      :total_cost,
      :description,
      :category,
      :profession,
      :fixed_costs,
      :start_date,
      :end_date
    )
  end
end
