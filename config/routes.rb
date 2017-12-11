Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :newests

  resources :coins do
  	get :autocomplete_coin_full_name, :on => :collection
  end

  resources :categories
  resources :portfolios

  post 'user_token' => 'user_token#create'
  get '/users/current-user', to: "current_user#show"
  resources :users
  mount Knock::Engine => "/knock"
  
end
