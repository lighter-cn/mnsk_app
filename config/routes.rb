Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'services#index'
  resources :services do
    resources :orders, only: [:new, :create] do
      member do
        get :pause
      end
    end
  end
  resources :cards, only: [:new, :create]
  resources :users, only: [:show, :edit, :update]
end
