Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'services#index'
  resources :services
  resources :cards, only: [:new, :create]
  resources :users, only: [:show, :edit, :update]
end
