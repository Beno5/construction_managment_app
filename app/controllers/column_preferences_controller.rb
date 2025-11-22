class ColumnPreferencesController < ApplicationController
  before_action :set_context

  def update
    table_key = params.require(:table_key)
    render_key = params[:render_key].presence || table_key
    selected_columns = Array(params[:columns]).map(&:to_s)
    selected_columns = available_columns(table_key) if selected_columns.empty?

    session[:column_preferences] ||= {}
    session[:column_preferences][table_key] = selected_columns

    selected_columns_map = {
      "tasks" => selected_columns_for("tasks"),
      "sub_tasks" => selected_columns_for("sub_tasks"),
      "project_tasks" => selected_columns_for("project_tasks")
    }

    payload = render_payload(render_key, selected_columns_map)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          payload[:frame_id],
          partial: payload[:partial],
          locals: payload[:locals]
        )
      end
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def render_payload(render_key, selected_columns_map)
    case render_key
    when "project_tasks"
      tasks = project_tasks_collection
      {
        frame_id: "table_tasks-frame",
        partial: "partials/table_expandable_task",
        locals: {
          tasks: tasks,
          project_task_columns: available_columns("project_tasks"),
          selected_project_task_columns: selected_columns_map["project_tasks"],
          business: @business,
          project: @project
        }
      }
    when "tasks"
      {
        frame_id: "#{render_key}_table",
        partial: "tasks/table",
        locals: {
          table_key: "tasks",
          available_columns: available_columns("tasks"),
          selected_columns: selected_columns_map["tasks"],
          records: table_records("tasks")
        }
      }
    when "sub_tasks"
      {
        frame_id: "#{render_key}_table",
        partial: "sub_tasks/table",
        locals: {
          table_key: "sub_tasks",
          available_columns: available_columns("sub_tasks"),
          selected_columns: selected_columns_map["sub_tasks"],
          records: table_records("sub_tasks")
        }
      }
    else
      raise ArgumentError, "Unknown render_key: #{render_key}"
    end
  end

  def available_columns(table_key)
    {
      "tasks" => %w[name description planned_start_date planned_end_date planned_cost],
      "sub_tasks" => %w[name description quantity unit_of_measure planned_start_date planned_end_date price_per_unit],
      "project_tasks" => %w[position name description unit_of_measure quantity planned_cost price_per_unit planned_start_date planned_end_date]
      # TODO: add columns for other tables
    }[table_key] || []
  end

  def selected_columns_for(key)
    session[:column_preferences] ||= {}
    session[:column_preferences][key] || available_columns(key)
  end

  def table_records(table_key)
    case table_key
    when "tasks"
      # TODO: adjust scope/ordering as needed
      @project&.tasks || Task.none
    when "sub_tasks"
      # TODO: adjust scope/ordering as needed
      @task&.sub_tasks || SubTask.none
    else
      []
    end
  end

  def project_tasks_collection
    return Task.none unless @project

    @project.tasks
            .search(params[:search])
            .order(:position)
            .page(params[:task_page])
            .per(10)
  end

  def set_context
    # TODO: extend when adding more tables/contexts
    @business = current_user.businesses.find_by(id: params[:business_id]) if params[:business_id].present?
    @project = @business.projects.find_by(id: params[:project_id]) if @business && params[:project_id].present?
    @task = @project.tasks.find_by(id: params[:task_id]) if @project && params[:task_id].present?
  end
end
