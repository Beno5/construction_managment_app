module Api
  class GanttController < ApplicationController
    def data
      project = Project.find_by(id: params[:id])
      return render json: { error: "Project not found" }, status: :not_found unless project

      tasks = project.tasks.includes(:sub_tasks)
      links = Link.where(source_id: tasks.pluck(:id) + tasks.flat_map { |t| t.sub_tasks.pluck(:id) })

      data = []

      tasks.each do |task|
        data << {
          id: task.id,
          name: task.name,
          position: task.position,
          start_date: task.planned_start_date&.strftime("%Y-%m-%d %H:%M:%S"),
          end_date: task.planned_end_date&.strftime("%Y-%m-%d %H:%M:%S"),
          parent: 0
        }

        task.sub_tasks.each do |sub_task|
          data << {
            id: sub_task.id,
            name: sub_task.name,
            position: sub_task.show_position,
            start_date: sub_task.planned_start_date&.strftime("%Y-%m-%d %H:%M:%S"),
            end_date: sub_task.planned_end_date&.strftime("%Y-%m-%d %H:%M:%S"),
            parent: task.id
          }
        end
      end

      render json: {
        data: data,
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
