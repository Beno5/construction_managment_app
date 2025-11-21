class ActivitiesController < ApplicationController
  before_action :set_sub_task
  before_action :set_activity, only: [:destroy]

  def new
    @activity = @sub_task.activities.new
  end

  def create
    if params[:activity][:activity_id].present? && params[:activity][:activity_id] != "undefined"
      @activity = Activity.find(params[:activity][:activity_id])
      if @activity.update(params_mapped)
        redirect_to business_project_task_sub_task_path(
          @sub_task.task.project.business,
          @sub_task.task.project,
          @sub_task.task,
          @sub_task
        ), notice: t('activities.messages.updated', name: @activity.activityable_type)

      else
        redirect_to business_project_task_sub_task_path(
          @sub_task.task.project.business,
          @sub_task.task.project,
          @sub_task.task,
          @sub_task
        ), alert: t('activities.messages.update_error')
      end

    else
      @activity = @sub_task.activities.new(params_mapped)

      if @activity.save
        redirect_to business_project_task_sub_task_path(
          @sub_task.task.project.business,
          @sub_task.task.project,
          @sub_task.task,
          @sub_task
        ), notice: t('activities.messages.created', name: @activity.activityable&.name || "Aktivnost")

      else
        redirect_to business_project_task_sub_task_path(
          @sub_task.task.project.business,
          @sub_task.task.project,
          @sub_task.task,
          @sub_task
        ), alert: t('activities.messages.create_error')
      end
    end
  end

  def update
    @activity = @sub_task.activities.find(params[:activity][:activity_id])

    # Check optimistic locking if record_updated_at is provided (inline editing)
    if params[:record_updated_at].present?
      record_updated_at = Time.parse(params[:record_updated_at])
      record_updated_at_sec = record_updated_at.change(usec: 0)
      activity_updated_at_sec = @activity.updated_at.change(usec: 0)

      if activity_updated_at_sec > record_updated_at_sec
        respond_to do |format|
          format.json do
            render json: {
              success: false,
              conflict: true,
              error: 'This record was modified by another user. Please refresh the page.'
            }, status: :conflict
          end
          format.html do
            redirect_to business_project_task_sub_task_path(@business, @project, @task, @sub_task),
                        alert: 'This record was modified by another user. Please refresh the page.'
          end
        end
        return
      end
    end

    if @activity.update(params_mapped)
      respond_to do |format|
        format.json do
          render json: {
            success: true,
            data: {
              id: @activity.id,
              quantity: @activity.quantity,
              unit_price: @activity.unit_price,
              total_price: @activity.total_price,
              updated_at: @activity.updated_at.iso8601
            }
          }, status: :ok
        end
        format.html do
          redirect_to project_task_sub_task_path(
            @sub_task.task.project,
            @sub_task.task,
            @sub_task
          ), notice: t('activities.messages.updated', name: @activity.activityable&.name || "Aktivnost")
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            success: false,
            errors: @activity.errors.full_messages
          }, status: :unprocessable_entity
        end
        format.html do
          flash.now[:alert] = t('activities.messages.update_error')
          render :edit
        end
      end
    end
  end

  def destroy
    # Uvijek sigurno dobavi naziv
    name =
      @activity.activityable&.name ||
      @activity.name ||
      t("activities.default_name", default: "Aktivnost")

    @activity.destroy

    respond_to do |format|
      format.turbo_stream do
        flash.now[:notice] = t("activities.messages.deleted", name: name)
        render turbo_stream: [
          turbo_stream.remove("activity_#{params[:id]}"),
          turbo_stream.update("flash_messages", partial: "partials/flash_messages")
        ]
      end

      format.html do
        redirect_back fallback_location: root_path,
                      notice: t("activities.messages.deleted", name: name)
      end
    end
  end

  private

  # ❗ PRAVILNO – više ne traži preko sub_task.activities
  def set_activity
    @activity = Activity.find_by(id: params[:id])

    return unless @activity.nil?

    redirect_back fallback_location: root_path,
                  alert: t("activities.messages.not_found",
                           default: "Aktivnost nije pronađena.") and return
  end

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
