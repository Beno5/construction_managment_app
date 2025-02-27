class CustomResourcesController < ApplicationController
  before_action :set_task
  before_action :set_custom_resource, only: [:edit, :update, :destroy]

  def new
    @custom_resource = @task.custom_resources.build
  end

  def edit; end

  def create
    puts "Received params: #{params.inspect}"
    @task = Task.find(params[:task_id])
    @custom_resource = @task.custom_resources.new(custom_resource_params)

    if @custom_resource.save
      respond_to do |format|
        format.turbo_stream
        format.html do
          redirect_to edit_business_project_task_path(@task.project.business, @task.project, @task),
                      notice: "Resource created."
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("custom-resource-modal", partial: "modals/modal_custom_resource",
                                                                             locals: { custom_resource: @custom_resource })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @custom_resource.update(custom_resource_params)
      redirect_to edit_task_path(@task), notice: "Custom resource successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @custom_resource.destroy
    redirect_to edit_task_path(@task), notice: "Custom resource successfully deleted."
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_custom_resource
    @custom_resource = @task.custom_resources.find(params[:id])
  end

  def custom_resource_params
    params.require(:custom_resource).permit(:name, :quantity, :unit_of_measure, :price_per_unit, :total_cost,
                                            :description, :category)
  end
end
