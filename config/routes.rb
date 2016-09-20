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
  get '/confirm_email/:confirmation_token', :to => "users#confirm_email", :as => 'email_confirmation'
  match '/forgotten_password', :via => [ :get, :post ], :to => "users#forgot_password", :as => 'forgotten_password'
  match '/reset_password/:password_reset_token', :via => [ :get, :post ], :to => "users#reset_password", :as => 'reset_password'

  get '/:id', :to => "theatre#performance", :as => 'performance'
end
