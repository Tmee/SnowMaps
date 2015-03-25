Rails.application.routes.draw do
  get "/auth/twitter/callback", to: "sessions#create"
  root 'sessions#new'
  delete '/logout', to: "sessions#destroy"

  get "search", to: "search#user_search"
  get '/today', to: 'mountains#today'
  get '/:mountain', to: 'mountains#show'

  resources :users

  get '/code' => redirect("https://github.com/Tmee/snow_maps")

end
