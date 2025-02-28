class CustomResourcesController < ApplicationController
  before_action :set_sub_task
  before_action :set_custom_resource, only: [:edit, :update, :destroy]

  def new
    @custom_resource = @sub_task.custom_resources.build
  end

  def edit; end

  def create
    ActiveRecord::Base.transaction do
      @custom_resource = @sub_task.custom_resources.new(custom_resource_params)
      @custom_resource.user = current_user
      @custom_resource.save!
  
      @sub_task.activities.create!(
        activity_type: @custom_resource.category,
        start_date: @sub_task.planned_start_date,
        end_date: @sub_task.planned_end_date,
        activityable: @custom_resource,
        quantity: @custom_resource.quantity,
        total_cost: @custom_resource.total_cost
      )
    end
  
    redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'planned'),
                notice: 'Custom resource i aktivnost uspešno kreirani.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to business_project_task_sub_task_path(@sub_task.task.project.business, @sub_task.task.project, @sub_task.task, @sub_task, anchor: 'planned'),
                alert: "Greška pri kreiranju custom resursa i aktivnosti: #{e.message}"
  end
  
  

  def update
    if @custom_resource.update(custom_resource_params)
      redirect_to edit_task_path(@sub_task.task), notice: "Custom resource successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      @custom_resource.activity.destroy if @custom_resource.activity
      @custom_resource.destroy!
    end
    redirect_to edit_task_path(@sub_task.task), notice: "Custom resource successfully deleted."
  rescue ActiveRecord::RecordInvalid
    redirect_to edit_task_path(@sub_task.task), alert: "Error deleting custom resource."
  end

  private

  def set_sub_task
    @sub_task = SubTask.find(params[:sub_task_id])
  end

  def set_custom_resource
    @custom_resource = @sub_task.custom_resources.find(params[:id])
  end

  def custom_resource_params
    params.require(:custom_resource).permit(:name, :first_name, :last_name, :quantity, :unit_of_measure, :price_per_unit,
     :total_cost, :description, :category, :profession, :fixed_costs)
  end
end