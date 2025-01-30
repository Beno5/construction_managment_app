Rails.application.routes.draw do
  devise_for :users
  root to: "businesses#index"

  # Business routes
  resources :businesses do
    resources :machines
    member do
      post :select # Ruta za odabir poslovanja
    end

    # Nested routes for projects and workers
    resources :projects do
      resources :tasks
      member do
        delete :remove_document
      end
    end

    resources :workers
  end

  # API routes for Gantt
  namespace :api do
    get "gantt/:type/:id/data", to: "gantt#data"
  
    resources :tasks, only: [] do
      collection do
        post :create_api
        put ":id", to: "tasks#update_api"  # ✅ Ispravljen put
        delete ":id", to: "tasks#destroy_api"
      end
    end
  
    resources :links, only: [:create, :update, :destroy]
  end
  
end
