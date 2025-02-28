class ActivitiesController < ApplicationController
  before_action :set_sub_task

  def new
    @activity = @sub_task.activities.new
  end

  def create
    @activity = @sub_task.activities.new(params_mapped)

    if @activity.save
      redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'planned'),
                  notice: 'Aktivnost je uspešno kreirana.'
    else
      redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'planned'),
                  alert: 'Greška pri kreiranju aktivnosti.'
    end
  end

  def update
    @activity = @sub_task.activities.find(params[:id])

    if @activity.update(activity_params)
      redirect_to project_task_sub_task_path(@sub_task.task.project, @sub_task.task, @sub_task),
                  notice: 'Aktivnost je uspešno ažurirana.'
    else
      render :edit
    end
  end

  def destroy
    @activity = @sub_task.activities.find(params[:id])
    @activity.destroy
    redirect_to project_task_sub_task_path(@sub_task.task.project, @sub_task.task, @sub_task),
                notice: 'Aktivnost je obrisana.'
  end

  private

  def set_sub_task
    @sub_task = SubTask.find(params[:sub_task_id])
  end

  def params_mapped
    {
      activity_type: activity_params[:category],
      start_date: @sub_task.planned_start_date,
      end_date: @sub_task.planned_end_date,
      activityable_id: @sub_task.id,
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
      :task_id,
      :category,
      :resource_id,
      :quantity,
      :unit_of_measure,
      :price_per_unit,
      :fixed_costs,
      :profession,
      :total_cost
    )
  end
end
