class RealActivitiesController < ApplicationController
  before_action :set_parents, only: [:new, :create, :update, :destroy]

  def new
    @real_activity = @activity.real_activities.build
  end

  def create
    if params[:real_activity][:real_activity_id].present? && params[:real_activity][:real_activity_id] != "undefined"
      @real_activity = RealActivity.find(params[:real_activity][:real_activity_id])
      if @real_activity.update(real_activity_params.merge(total_cost: calculate_total_cost))
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'real'),
                    notice: 'Aktivnost je uspešno ažurirana.'
      else
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'real'),
                    alert: 'Greška pri ažuriranju aktivnosti.'
      end
    else
      @real_activity = @activity.real_activities.new(real_activity_params.merge(total_cost: calculate_total_cost))
      @real_activity.user = current_user
      @real_activity.sub_task = @sub_task
      if @real_activity.save
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'real'),
                    notice: 'Aktivnost je uspešno kreirana.'
      else
        redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'real'),
                    alert: 'Greška pri kreiranju aktivnosti.'
      end
    end
  end

  def update
    @real_activity = @activity.real_activities.find(params[:real_activity][:real_activity_id])

    if @real_activity.update(real_activity_params.merge(total_cost: calculate_total_cost))
      redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'real'),
                  notice: 'Aktivnost je uspešno ažurirana.'
    else
      render :edit
    end
  end

  def destroy
    @real_activity = @activity.real_activities.find(params[:id])
    @real_activity.destroy

    respond_to do |format|
      format.turbo_stream
      format.html do
        redirect_to business_project_task_sub_task_path(business, @project, @task, @sub_task, anchor: 'real'),
                    notice: "Real activity was successfully deleted."
      end
    end
  end

  private

  def set_parents
    @activity = Activity.find(params[:activity_id])
    @sub_task = @activity.sub_task
    @task = @sub_task.task
    @project = @task.project
    @business = @project.business
  end

  def real_activity_params
    params.require(:real_activity).permit(:quantity, :start_date, :end_date)
  end

  def calculate_total_cost
    # Računaj ukupni trošak
    price_per_unit = @activity.activityable.price_per_unit
    quantity = params.dig(:real_activity, :quantity).to_i

    # Vraćaj izračunati ukupni trošak
    price_per_unit * quantity
  end
end
