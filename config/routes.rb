Rails.application.routes.draw do
  devise_for :users
  root to: "projects#index"

  # Business routes
  resources :businesses do
    member do
      post :select # Ruta za odabir poslovanja
    end

    # Nested routes for projects and workers
    resources :projects do
      resources :tasks
    end
    resources :workers
  end

  # API scope for tasks (Gantt chart)
  scope '/api' do
    get "/data", to: "tasks#gantt_data"
    post "/task", to: "tasks#add_task"
    put "/task/:id", to: "tasks#update_task"
    delete "/task/:id", to: "tasks#delete_task"
  end
end
