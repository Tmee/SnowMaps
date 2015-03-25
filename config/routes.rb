Rails.application.routes.draw do
  get '/code' => redirect("https://github.com/Tmee/snow_maps")
  get "/auth/twitter/callback", to: "sessions#create"
  root 'sessions#new'
  delete '/logout', to: "sessions#destroy"

  get "search", to: "search#user_search"
  get '/today', to: 'mountains#today'
  get '/:mountain', to: 'mountains#show'

  resources :users

end
