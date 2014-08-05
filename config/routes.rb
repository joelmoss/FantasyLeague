Rails.application.routes.draw do

  devise_for :managers

  root 'pages#index'

  resources :teams
  resources :players, only: [ :index, :show ]
  resources :managers, except: [ :new, :create ] do
    member do
      patch 'approve'
    end
  end

end
