Rails.application.routes.draw do
  # Devise rute
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Ostale potrebne rute
  get 'pages/home'

  # Root stranica aplikacije
  root to: 'pages#home'
end
