class PinnedNormsController < ApplicationController
  before_action :set_sub_task

  def create
    @sub_task.pinned_norms << Norm.find(params[:norm_id]) unless @sub_task.pinned_norms.exists?(params[:norm_id])
    head :ok
  end

  def destroy
    @sub_task.pinned_norms.destroy(Norm.find(params[:norm_id]))
    head :ok
  end

  private

  def set_sub_task
    @sub_task = SubTask.find(params[:sub_task_id])
  end
end
