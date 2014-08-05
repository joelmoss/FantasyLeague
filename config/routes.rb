Rails.application.routes.draw do

  devise_for :managers
  root 'pages#index'

  resources :players, only: [ :index, :show ]
  resources :managers, except: [ :new, :create ]

end
