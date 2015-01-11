Rails.application.routes.draw do
  root 'users#index'
  get '/today', to: 'users#today'
  resources :users

  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
end
