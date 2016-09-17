Rails.application.routes.draw do
  resources :stages
  resources :media
  resources :stage_media, :only => [ :create, :destroy ]
  resources :roles
  resources :users
  resources :user_roles, :only => [ :create, :destroy ]

  root "theatre#foyer"

  get '/login', :to => "sessions#new", :as => 'login'
  post '/login', :to => "sessions#create"
  get '/logout', :to => "sessions#destroy", :as => 'logout'
  get '/foyer', :to => "theatre#foyer", :as => 'foyer'
  get '/register', :to => "users#new", :as => 'registration'

  get '/:id', :to => "theatre#performance", :as => 'performance'
end
