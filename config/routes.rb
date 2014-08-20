Rails.application.routes.draw do

  devise_for :managers

  root 'dashboard#index'

  page 'rules'

  resources :teams do
    resources :team_players, path: :players, as: :players, except: [:index] do
      post :toggle_sub, on: :member
      delete :release, on: :member
    end
  end

  resources :players, only: [ :index, :show, :update ] do
    post :watch, on: :member
    delete :unwatch, on: :member
    post :toggle_watch, on: :member
    get :watching, on: :collection

    resources :sealed_bids
  end

  resources :managers, except: [ :new, :create ] do
    patch :approve, on: :member
  end

  resources :fixtures, only: [ :index, :show ]

  resources :conversations do
    resources :messages
    # member do
    #   post :reply
    #   post :trash
    #   post :untrash
    # end
  end

end
