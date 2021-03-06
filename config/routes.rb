Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :newests

  resources :coins do
  	get :autocomplete_coin_full_name, :on => :collection
  end

  resources :categories

  post 'user_token' => 'user_token#create'
  get '/users/current-user', to: "current_user#show"
  get '/user_info', to: "users#show"
  put '/users', to: "users#update"
  resources :users
  resources :portfolios
  mount Knock::Engine => "/knock"


  resources :password_resets,     only: [:create, :update]

  get '/public_portfolio/:user_id/:portfolio_id', to: "users#public_portfolio"
  get '/sync', to: "users#data"
  post '/sync', to: "users#data_update"

end
