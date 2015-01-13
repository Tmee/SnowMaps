Rails.application.routes.draw do
  root 'users#index'
  get '/today', to: 'users#today'
  resources :users
  get '/:mountain', to: 'mountains#show'

  get '/login' => 'sessions#new',  as: :login
  post '/login' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
end
