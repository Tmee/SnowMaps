Rails.application.routes.draw do
  get "/auth/twitter/callback", to: "sessions#create"
  root 'users#index'

  get '/today', to: 'users#today'
  get "search", to: "search#user_search"
  get '/:mountain', to: 'mountains#show'

  resources :users

  delete '/logout', to: "sessions#destroy"
end
