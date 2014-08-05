Rails.application.routes.draw do

  root 'pages#index'

  resources :players, only: [ :index, :show ]

end
