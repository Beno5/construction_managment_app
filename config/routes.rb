Rails.application.routes.draw do
  require "sidekiq/web"

  # (opcionalno kasnije zaštititi admin authom:
  # authenticate :user, ->(u) { u.admin? } do
  #   mount Sidekiq::Web => "/sidekiq"
  # end
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, controllers: {
    passwords: 'users/passwords',
    registrations: 'users/registrations',
      sessions: 'users/sessions'
  }
  root to: "businesses#index"

  # Business routes
  
  resources :businesses do
    resources :norms
    resources :machines
    resources :workers
    resources :materials
    member do
      post :select # Ruta za odabir poslovanja
    end

    resources :projects do
        post :import_ai, on: :collection
        get :import_status, on: :collection
        delete :cancel_import, on: :collection
      resources :tasks do
        resources :sub_tasks do
          post "pinned_norms/:norm_id", to: "pinned_norms#create"
          delete "pinned_norms/:norm_id", to: "pinned_norms#destroy"
          resources :custom_resources, only: [:new, :create, :edit, :update, :destroy]
          resources :activities, only: [:new, :create, :update, :destroy] do
            resources :real_activities, only: [:new, :create, :update, :destroy]
          end
          resources :documents, only: [:new, :create, :edit, :update, :destroy, :show]
        end
        resources :documents, only: [:new, :create, :edit, :update, :destroy, :show], shallow: true

      end
      resources :documents, only: [:new, :create, :edit, :update, :destroy, :show], shallow: true
    end
  end

  # API routes for Gantt
  namespace :api do
    put "/gantt/move_update/:id", to: "gantt#move_update"
    get "gantt/project/:id/data", to: "gantt#data" # Samo učitavanje podataka
    resources :links, only: [:create, :destroy] # Samo kreiranje i brisanje linkova
  end

  get 'fetch_data/unit_options', to: 'fetch_data#unit_options'
  get 'fetch_data/resources', to: 'fetch_data#resources'
  get 'fetch_data/resource_details', to: 'fetch_data#resource_details'
  get 'fetch_data/get_activity_and_resource_infos/:id', to: 'fetch_data#get_activity_and_resource_infos'
  get 'fetch_data/get_document/:id', to: 'fetch_data#get_document'
  get 'fetch_data/check_activity/:item_id/:item_type', to: 'fetch_data#check_activity'
  get 'fetch_data/get_activity_and_real_activity_infos/:activity_id/:real_activity_id', to: 'fetch_data#get_activity_and_real_activity_infos'
end
