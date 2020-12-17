Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get 'card', to: 'users/registrations#new_card'
    post 'card', to: 'users/registrations#create_card'
  end
  root 'services#index'
end
