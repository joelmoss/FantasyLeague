Rails.application.routes.draw do

  devise_for :managers

  root 'dashboard#index'

  page 'rules'

  resources :teams do
    resources :team_players, path: :players, as: :players, except: [:index] do
      member do
        post :toggle_sub
        post :toggle_transfer_listed
        delete :release
      end
    end

    member do
      get :team_sheet
      get :results
    end

    collection do
      get :weeks
      get :months
    end
  end

  resources :players, only: [ :index, :show, :update ] do
    member do
      post :watch
      delete :unwatch
      post :toggle_watch
    end
    collection do
      get :watching
      get :transfer_listed
    end
    resources :sealed_bids
  end

  resources :managers, except: [ :new, :create ] do
    patch :approve, on: :member
  end

  namespace :results do
    resources :matches, only: [ :index, :show ]
    resources :teams, only: [ :index, :show ]
  end

  resources :conversations do
    resources :messages
  end

end
