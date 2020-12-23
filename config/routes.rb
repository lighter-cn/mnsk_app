Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'services#index'
  resources :services do
    resources :orders, only: [:new, :create] do
      member do
        get :pause
        get :resume
      end
    end
  end
  resources :cards, only: [:new, :create]
  resources :users, only: [:show, :edit, :update]
  resources :codes, only: [:show, :new, :create, :update]
end
