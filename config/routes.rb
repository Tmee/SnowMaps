Rails.application.routes.draw do
  root 'users#index'
  get '/today', to: 'users#today'
  resources :users
  get '/:mountain', to: 'mountains#show'


  get "/auth/twitter/callback", to: "sessions#create"
  get "/signout", to: "sessions#destroy", :as => :signout
  get '/auth/twitter', to: 'sessions#new',  as: :login
end
