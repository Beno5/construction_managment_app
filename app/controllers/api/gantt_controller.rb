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
          id: "t_#{task.id}",                         # prefiks za Task
          name: task.name,
          position: task.position,
          start_date: task.planned_start_date&.strftime("%Y-%m-%d"),
          end_date: task.planned_end_date&.strftime("%Y-%m-%d"),
          parent: 0
        }

        task.sub_tasks.each do |sub_task|
          data << {
            id: "st_#{sub_task.id}",                  # prefiks za SubTask
            name: sub_task.name,
            position: sub_task.show_position,
            start_date: sub_task.planned_start_date&.strftime("%Y-%m-%d"),
            end_date: sub_task.planned_end_date&.strftime("%Y-%m-%d"),
            parent: "t_#{task.id}"                    # SubTask je dijete Taska
          }
        end
      end

      render json: {
        data: data,
        links: links.map do |link|
          {
            id: link.id,
            source: normalize_id(link.source_id),
            target: normalize_id(link.target_id),
            type: link.link_type
          }
        end
      }
    end

    def move_update
      raw_id = params[:id].to_s

      if raw_id.start_with?("t_")
        record = Task.find(raw_id.sub("t_", ""))
      elsif raw_id.start_with?("st_")
        record = SubTask.find(raw_id.sub("st_", ""))
      else
        return render json: { action: "error", errors: ["Invalid ID format"] }, status: :unprocessable_entity
      end

      attrs = {
        planned_start_date: params[:start_date].present? ? Date.parse(params[:start_date]) : nil,
        planned_end_date: params[:end_date].present? ? Date.parse(params[:end_date]) : nil,
        duration: params[:duration]
      }.compact

      if record.update(attrs)
        render json: { action: "updated", record: record }
      else
        render json: { action: "error", errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def permitted_params
      # Mapiramo iz Gantt formata u naše kolone
      {
        planned_start_date: params[:start_date],
        planned_end_date: params[:end_date],
        duration: params[:duration]
      }.compact
    end

    def permitted_params
      params.permit(:start_date, :end_date, :duration)
    end

    # Helper da prefiksira i linkove
    def normalize_id(raw_id)
      if Task.exists?(raw_id)
        "t_#{raw_id}"
      elsif SubTask.exists?(raw_id)
        "st_#{raw_id}"
      else
        raw_id
      end
    end
  end
end
