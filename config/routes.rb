Rails.application.routes.draw do
  devise_for :users
  root to: "projects#index"

  resources :projects do
    resources :tasks
  end

  scope '/api' do
    get "/data", to: "tasks#gantt_data"
    post "/task", to: "tasks#add_task"
    put "/task/:id", to: "tasks#update_task"
    delete "/task/:id", to: "tasks#delete_task"
  end
end
