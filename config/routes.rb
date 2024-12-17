Rails.application.routes.draw do
  devise_for :users
  
  # Postavi root na index akciju projects kontrolera
  root to: "projects#index"

  resources :projects
end
