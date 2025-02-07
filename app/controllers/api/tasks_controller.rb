module Api
  class TasksController < ApplicationController
    before_action :set_task, only: [:update_api, :destroy_api]
    protect_from_forgery with: :null_session # ✅ Omogućava API pozive bez CSRF tokena

    # ✅ Kreiranje novog taska kroz API
    def create_api
      task = Task.new(api_task_params)

      if task.save
        render json: { action: "inserted", tid: task.id }
      else
        render json: { action: "error", errors: task.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # ✅ Ažuriranje taska (pomicanje na novi datum)
    def update_api
      task_params = params.require(:task).permit(:text, :start_date, :end_date, :duration, :progress)
    
      # Parsiraj datume
      start_date = DateTime.strptime(task_params[:start_date], "%Y-%m-%d %H:%M:%S") if task_params[:start_date].present?
      end_date = DateTime.strptime(task_params[:end_date], "%Y-%m-%d %H:%M:%S") if task_params[:end_date].present?
    
      # Ažuriraj task
      if @task.update(description: task_params[:text], planned_start_date: start_date, planned_end_date: end_date, progress: task_params[:progress])
        render json: { action: "updated", task: @task }
      else
        render json: { action: "error", errors: @task.errors.full_messages }, status: :unprocessable_entity
      end
    end
    

    # ✅ Brisanje taska kroz API
    def destroy_api
      if @task.destroy
        render json: { action: "deleted" }
      else
        render json: { action: "error", errors: ["Task not found"] }, status: :not_found
      end
    end

    private

    # ⏳ Dohvati task po ID-ju
    def set_task
      @task = Task.find_by(id: params[:id])
      return render json: { error: "Task not found" }, status: :not_found unless @task
    end

    # 🛠 Obradi parametre
    def api_task_params
      params.require(:task).permit(:text, :start_date, :duration, :progress).transform_keys do |key|
        case key.to_sym
        when :text then :description
        when :start_date then :planned_start_date
        when :duration then :planned_end_date
        else key.to_sym
        end
      end
    end
    
  end
end


# Napravio si da radi gant medjutim imas problem sa parametrima kada salje, moras to izgleda rucno.
# Kada se pomjera da update kako treba, mozda za pocetak da napravis da se vidi samo i povezuje a da se vrijeme edituje gore.
# Takodjer ni link ne radi, znaci generalno taj api nije dobar tj interakcija na gantu. 