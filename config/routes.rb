Rails.application.routes.draw do
  devise_for :users
  root to: "businesses#index"

  # Business routes
  resources :businesses do
    resources :machines
    resources :workers
    resources :materials
    member do
      post :select # Ruta za odabir poslovanja
    end

    resources :projects do
      resources :tasks do
        resources :sub_tasks do
          resources :custom_resources, only: [:new, :create, :edit, :update, :destroy]
          resources :activities, only: [:new, :create, :update, :destroy]
        end
      end
      member do
        delete :remove_document
      end
    end
  end

  # API routes for Gantt
  namespace :api do
    get "gantt/project/:id/data", to: "gantt#data" # Samo učitavanje podataka
    resources :links, only: [:create, :destroy] # Samo kreiranje i brisanje linkova
  end

  get 'fetch_data/unit_options', to: 'fetch_data#unit_options'
  get 'fetch_data/resources', to: 'fetch_data#resources'
  get 'fetch_data/resource_details', to: 'fetch_data#resource_details'
  get 'fetch_data/:id', to: 'fetch_data#get_activity'
end
