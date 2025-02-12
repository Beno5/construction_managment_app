Rails.application.routes.draw do
  get 'materials/index'
  get 'materials/show'
  get 'materials/new'
  get 'materials/create'
  get 'materials/edit'
  get 'materials/update'
  get 'materials/destroy'
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
    resources :materials
  end

  # API routes for Gantt
  namespace :api do
    get "gantt/project/:id/data", to: "gantt#data" # Samo učitavanje podataka

    resources :links, only: [:create, :destroy] # Samo kreiranje i brisanje linkova
  end
end
