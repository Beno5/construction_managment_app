module Api
  class GanttController < ApplicationController
    def data
      project = Project.find_by(id: params[:id])
      return render json: { error: "Project not found" }, status: :not_found unless project

      tasks = project.tasks
      links = Link.where(source_id: tasks.pluck(:id)) # Pronađi linkove samo za ovaj projekat

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
