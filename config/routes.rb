Rails.application.routes.draw do

  devise_for :managers

  root 'dashboard#index'

  resources :teams do
    resources :team_players, path: :players, as: :players, except: [:index]
  end
  resources :players, only: [ :index, :show ]
  resources :managers, except: [ :new, :create ] do
    patch :approve, on: :member
  end

end
