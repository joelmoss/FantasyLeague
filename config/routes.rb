Rails.application.routes.draw do

  devise_for :managers

  root 'dashboard#index'

  page 'rules'

  resources :teams do
    resources :team_players, path: :players, as: :players, except: [:index]
  end
  resources :players, only: [ :index, :show ] do
    post :watch, on: :member
    delete :unwatch, on: :member
    get :watching, on: :collection
  end
  resources :managers, except: [ :new, :create ] do
    patch :approve, on: :member
  end

end
