class ActivitiesController < ApplicationController
  before_action :set_sub_task

  def new
    @activity = @sub_task.activities.new
  end

  def create
    if params[:activity][:activity_id].present? && params[:activity][:activity_id] != "undefined"
      @activity = Activity.find(params[:activity][:activity_id])
      if @activity.update(params_mapped)

        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    notice: t('activities.messages.updated', name: @activity.activityable_type)
      else
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    alert: t('activities.messages.update_error')
      end
    else
      @activity = @sub_task.activities.new(params_mapped)
      if @activity.save
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    notice: t('activities.messages.created', name: @activity.activityable.name)
      else
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task),
                    alert: t('activities.messages.create_error')
      end
    end
  end

  def update
    @activity = @sub_task.activities.find(params[:activity][:activity_id])

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
      format.turbo_stream # koristi destroy.turbo_stream.erb
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

  def params_mapped
    {
      activity_type: activity_params[:category],
      start_date: activity_params[:start_date],
      end_date: activity_params[:end_date],
      activityable_id: activity_params[:resource_id],
      activityable_type: activity_params[:category].capitalize,
      quantity: activity_params[:quantity],
      total_cost: activity_params[:total_cost]
    }
  end

  def activity_params
    params.require(:activity).permit(
      :name,
      :description,
      :date,
      :category,
      :resource_id,
      :quantity,
      :unit_of_measure,
      :price_per_unit,
      :fixed_costs,
      :profession,
      :total_cost,
      :activity_id,
      :start_date,
      :end_date
    )
  end
end
