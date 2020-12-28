Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'services#index'
  resources :services do
    member do
      patch :pause
      patch :resume
    end
    resources :orders, only: [:new, :create] do
      member do
        patch :pause
        patch :resume
      end
    end
  end
  resources :cards, only: [:new, :create]
  resources :users, only: [:show, :edit, :update]
  resources :codes, only: [:show, :create, :update]
end
