module Api
  class GanttController < ApplicationController
    def data
      case params[:type]
      when "project"
        project = Project.find(params[:id])
        tasks = project.tasks
        links = project.links
      else
        return render json: { error: "Invalid Gantt type" }, status: :bad_request
      end

      render json: {
        data: tasks.map do |task|
          {
            id: task.id,
            text: task.description,
            start_date: task.planned_start_date.strftime("%Y-%m-%d %H:%M:%S"),
            duration: (task.planned_end_date - task.planned_start_date).to_i,
            progress: task.progress || 0
          }
        end,
        links: links.map do |link|
          {
            id: link.id,
            source: link.source_id,
            target: link.target_id,
            type: link.link_type
          }
        end
      }
    end
  end
end
