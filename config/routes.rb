Rails.application.routes.draw do
  get 'media/index'

  resources :tags, :param => :name, :except => [ :edit, :update ]
  resources :avatar_stages, :only => [ :create, :destroy ]
  resources :sounds, :param => :slug do
    resources :tags, :param => :name, :except => [ :edit, :update ]
  end
  resources :avatars do
    resources :tags, :param => :name, :except => [ :edit, :update ]
  end
  resources :stages do
    resources :tags, :param => :name, :except => [ :edit, :update ]
    post '/clone', :to => "stages#clone", :as => 'clone'
  end
  resources :roles
  resources :users
  resources :user_roles, :only => [ :create, :destroy ]
  resources :messages


  mount ActionCable.server => '/cable'


  root "theatre#foyer"

  get '/login', :to => "sessions#new", :as => 'login'
  post '/login', :to => "sessions#create"
  get '/logout', :to => "sessions#destroy", :as => 'logout'
  get '/foyer', :to => "theatre#foyer", :as => 'foyer'
  get '/register', :to => "users#new", :as => 'registration'
  get '/confirm_email/:confirmation_token', :to => "users#confirm_email", :as => 'email_confirmation'
  match '/forgotten_password', :via => [ :get, :post ], :to => "users#forgot_password", :as => 'forgotten_password'
  match '/reset_password/:password_reset_token', :via => [ :get, :post ], :to => "users#reset_password", :as => 'reset_password'
  get '/media', :to => "media#index", :as => 'media'

  get '/:id', :to => "theatre#performance", :as => 'performance'


  post "/updatedrawing", :to => "theatre#show_drawing"
  post "/updateaudio", :to => "theatre#audio_control"
end
