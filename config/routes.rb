Fetedelamusique::Application.routes.draw do

  devise_for :admins
  resources :concerts
  resources :venues

  root 'venues#index'
end
