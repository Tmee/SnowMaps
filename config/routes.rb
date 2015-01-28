Rails.application.routes.draw do
  root 'users#index'
  resources :users
  get '/today', to: 'users#today'
  get "search", to: "search#user_search"
  get '/:mountain', to: 'mountains#show'

  #Twitter routes + sessions
  get "/auth/twitter/callback", to: "sessions#create"
  delete '/logout', to: "sessions#destroy"
  get '/auth/twitter', to: 'sessions#new',  as: :login
end
