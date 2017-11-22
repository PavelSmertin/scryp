Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :newests

  resources :coins do
  	get :autocomplete_coin_full_name, :on => :collection
  end

  resources :categories
  
end
