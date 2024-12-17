Rails.application.routes.draw do
  get 'projects/index'
  get 'projects/new'
  get 'projects/create'
  get 'projects/show'
  get 'projects/edit'
  get 'projects/update'
  get 'projects/destroy'
  # Devise rute
  devise_for :users
  
  resources :projects


  # Ostale potrebne rute
  get 'pages/home'

  # Root stranica aplikacije
  root to: 'pages#home'
end
