module Api
  class GanttController < ApplicationController
    def data
      project = Project.find_by(id: params[:id])
      return render json: { error: "Project not found" }, status: :not_found unless project

      tasks = project.tasks.includes(:sub_tasks)
      links = Link.where(source_id: tasks.pluck(:id) + tasks.flat_map { |t| t.sub_tasks.pluck(:id) })

      data = []

      tasks.each do |task|
        task_data = {
          id: "t_#{task.id}", # prefiks za Task
          name: task.name,
          position: task.position,
          parent: 0,
          open: true
        }

        if task.planned_start_date && task.planned_end_date
          task_data[:start_date] = task.planned_start_date.to_time.strftime("%Y-%m-%d %H:%M:%S")
          task_data[:duration] = task.calculate_duration
        else
          task_data[:unscheduled] = true
          task_data[:duration] = 0
        end

        data << task_data

        task.sub_tasks.each do |sub_task|
          sub_data = {
            id: "st_#{sub_task.id}", # prefiks za SubTask
            name: sub_task.name,
            position: sub_task.show_position,
            parent: "t_#{task.id}"   # SubTask je dijete Taska
          }

          if sub_task.planned_start_date && sub_task.planned_end_date
            sub_data[:start_date] = sub_task.planned_start_date.to_time.strftime("%Y-%m-%d %H:%M:%S")
            sub_data[:duration] = sub_task.calculate_duration
          else
            sub_data[:unscheduled] = true
            sub_data[:duration] = 0
          end

          data << sub_data
        end
      end

      data.sort_by! do |item|
        item[:position].to_s.split('.').map(&:to_i)
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

      # Identify record type
      if raw_id.start_with?("t_")
        record = Task.find(raw_id.sub("t_", ""))
      elsif raw_id.start_with?("st_")
        record = SubTask.find(raw_id.sub("st_", ""))
      else
        return render json: { action: "error", errors: ["Invalid ID format"] }, status: :unprocessable_entity
      end

      # Parse incoming params
      start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
      duration   = params[:duration].to_i if params[:duration].present?

      # Apply inclusive logic:
      # end_date = start_date + (duration - 1)
      end_date = nil
      end_date = start_date + (duration - 1).days if start_date && duration && duration > 0

      # Update record
      if record.update(planned_start_date: start_date,
                       planned_end_date: end_date,
                       duration: duration)

        # Broadcast updates to gantt, table, forms
        broadcast_refresh_gantt_event(record)
        broadcast_table_refresh(record)
        broadcast_form_refresh(record)

        render json: { action: "updated", record: record }
      else
        render json: { action: "error", errors: record.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def broadcast_refresh_gantt_event(record)
      project = record.is_a?(Task) ? record.project : record.task.project

      # Broadcast to project-level Gantt (projects/show)
      Turbo::StreamsChannel.broadcast_append_to(
        "project_#{project.id}_gantt",
        target: "gantt-events",
        html: "<script>document.dispatchEvent(new CustomEvent('refresh-gantt'));</script>"
      )

      # Broadcast to task-level Gantt (tasks/show) if it's a SubTask
      return unless record.is_a?(SubTask)

      Turbo::StreamsChannel.broadcast_append_to(
        "task_#{record.task.id}_gantt",
        target: "gantt-events",
        html: "<script>document.dispatchEvent(new CustomEvent('refresh-gantt'));</script>"
      )

      # Broadcast to subtask-level Gantt (sub_tasks/show)
      Turbo::StreamsChannel.broadcast_append_to(
        "sub_task_#{record.id}_gantt",
        target: "gantt-events",
        html: "<script>document.dispatchEvent(new CustomEvent('refresh-gantt'));</script>"
      )
    end

    def broadcast_table_refresh(record)
      project = record.is_a?(Task) ? record.project : record.task.project

      # Broadcast to project-level table (projects/show - tasks table)
      Turbo::StreamsChannel.broadcast_append_to(
        "project_#{project.id}_table",
        target: "gantt-events",
        html: "<script>document.dispatchEvent(new CustomEvent('refresh-table'));</script>"
      )

      # Broadcast to task-level table (tasks/show - subtasks table) if it's a SubTask
      return unless record.is_a?(SubTask)

      Turbo::StreamsChannel.broadcast_append_to(
        "task_#{record.task.id}_table",
        target: "gantt-events",
        html: "<script>document.dispatchEvent(new CustomEvent('refresh-table'));</script>"
      )
    end

    def broadcast_form_refresh(record)
      if record.is_a?(Task)
        # Broadcast to task-level form (tasks/show)
        Turbo::StreamsChannel.broadcast_append_to(
          "task_#{record.id}_gantt",
          target: "gantt-events",
          html: "<script>document.dispatchEvent(new CustomEvent('refresh-form'));</script>"
        )
      elsif record.is_a?(SubTask)
        # Broadcast to subtask-level form (sub_tasks/show)
        Turbo::StreamsChannel.broadcast_append_to(
          "sub_task_#{record.id}_gantt",
          target: "gantt-events",
          html: "<script>document.dispatchEvent(new CustomEvent('refresh-form'));</script>"
        )
      end
    end

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
