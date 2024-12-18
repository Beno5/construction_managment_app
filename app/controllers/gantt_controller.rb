class GanttController < ApplicationController
  def data
    tasks = Task.all
    links = Link.all

    render json: {
      data: tasks.map { |task|
        {
          id: task.id,
          text: task.text,
          start_date: task.start_date.strftime("%Y-%m-%d %H:%M:%S"),
          duration: task.calculate_duration ,
          progress: task.progress,
          parent: task.parent || 0
        }
      },
      links: links.map { |link|
        {
          id: link.id,
          source: link.source,
          target: link.target,
          type: link.link_type
        }
      }
    }
  end
end
