Radon::Application.routes.draw do

  resources :roles
  resources :users
  resources :announcements

  root to: "pages#show", :name => 'home'
#  root to: "samples#index", constraints: lambda { |r| Page.where(:name => "home").blank? }, as: :samples_root

  resources :prmats

  resources :locations
  
  get '/locations/search', :to => 'locations#search'

  get '/simple_captcha/:action' => 'simple_captcha#index', :as => :simple_captcha
  resources :pages, :except => "show" do
    collection do
      post :sort
    end
  end

  get 'pages/:name' => 'pages#show'
  resources :comments
  resources :literatures_samples
  resources :searches do
    collection do
  post :edit_multiple
  end
  
  
  end

  resources :rights do
    collection do
  post :sort
  end
  
  end
  
#  get '/mapping/search', :to => 'mapping#search'
  
  resources :roles
  get 'signup' => 'users#new', :as => :signup
  get 'logout' => 'user_sessions#destroy', :as => :logout
  get 'login' => 'user_sessions#new', :as => :login
#  match '/' => 'pages#show', :name => 'home' unless Page.where(:name => "home").blank?
#  match '/' => 'samples#index'
  resources :user_sessions
  resources :users
  resources :dating_methods do
    collection do
  post :sort
  end
  
  
  end

  resources :prmats do
    collection do
  post :sort
  end
  
  
  end

  resources :feature_types do
    collection do
  post :sort
  end
  
  
  end

  resources :literatures do
   collection do
     get :autocomplete
     get :without_bibtex
   end
   get :un_api
   get :un_api, on: :collection
  end

  resources :countries do
    collection do
      post :sort
    end
  end

  resources :country_subdivisions do
    collection do
      post :get_country_subdivisions_by_country
      post :sort
    end
  end

  resources :sites do
    collection do
  post :get_sites_by_country_subdivision
  get :without_geolocalisation
  post :sort
  get :with_geolocalisation
  end
  
  
  end

  resources :labs do
    collection do
  post :sort
  end
  
  
  end

  resources :samples do
    collection do
     get :calibrate_multi
     get :calibrate
     get :calibrate_sum
     post :export_chart
  end
  
  
  end

  resources :samples do
  
    member do
  post :auto_complete_for_site_name
  end
      resources :sites do
        collection do
    get :site
    end
    
    
    end
  end

  resources :phases do
    collection do
  post :get_phases_by_culture
  post :sort
  end
  
  
  end

  resources :cultures do
    collection do
  post :sort
  end
  
  
  end

#  match '/:controller(/:action(/:id))'
end
