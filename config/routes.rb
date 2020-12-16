Rails.application.routes.draw do
  devise_for :users
  root 'services#index'
end
