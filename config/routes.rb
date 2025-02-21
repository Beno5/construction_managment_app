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
        resources :custom_resources, only: [:new, :create, :edit, :update, :destroy]
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

end
