class PinnedNormsController < ApplicationController
  before_action :set_sub_task

  def create
    norm = Norm.find(params[:norm_id])
    if !@sub_task.pinned_norms.exists?(norm.id)
      @sub_task.pinned_norms << norm
      SubTaskPlanningCalculator.new(@sub_task).call(norms: true)
    end

    render json: sub_task_response_data
  end

  def destroy
    norm = Norm.find(params[:norm_id])
    if @sub_task.pinned_norms.exists?(norm.id)
      @sub_task.pinned_norms.destroy(norm)
      SubTaskPlanningCalculator.new(@sub_task).call(norms: true)
    end

    render json: sub_task_response_data
  end

  private

  def set_sub_task
    @sub_task = SubTask.find(params[:sub_task_id])
  end

  def sub_task_response_data
    @sub_task.slice(:duration, :num_workers_skilled, :num_workers_unskilled, :num_machines).merge(success: true)
  end
end
