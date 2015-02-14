Rails.application.routes.draw do
  get "/auth/twitter/callback", to: "sessions#create"
  root 'sessions#new'

  get "search", to: "search#user_search"
  get '/today', to: 'mountains#today'
  get '/:mountain', to: 'mountains#show'

  resources :users

  delete '/logout', to: "sessions#destroy"
end
