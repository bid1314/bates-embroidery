Rails.application.routes.draw do
  # Mount Spree at /admin for backend management
  mount Spree::Core::Engine, at: '/admin'
  devise_for :users
  
  # Subdomain-based routing
  constraints subdomain: 'retail' do
    root 'retail/home#index', as: :retail_root
    namespace :retail do
      resources :products, only: [:index, :show] do
        member do
          get :customize
          post :save_customization
        end
      end
    end
  end
  
  constraints subdomain: 'b2b' do
    root 'b2b/home#index', as: :b2b_root
    namespace :b2b do
      get 'login', to: 'home#login', as: :login
      get 'register', to: 'home#register', as: :register
      resources :products, only: [:index, :show] do
        member do
          get :customize
          post :save_customization
        end
      end
      get 'pricing', to: 'pricing#index'
      get 'account/apply', to: 'account#apply'
      post 'account/submit_application', to: 'account#submit_application'
    end
  end
  
  # Default root route (fallback to retail)
  root "retail/home#index"
  
  # Product routes
  resources :products, only: [:index, :show] do
    member do
      get :customize
      post :save_customization
    end
  end
  
  # Shopping cart routes
  get 'cart', to: 'shopping_cart#show'
  post 'cart/add_item', to: 'shopping_cart#add_item'
  delete 'cart/remove_item', to: 'shopping_cart#remove_item'
  patch 'cart/update_quantity', to: 'shopping_cart#update_quantity'
  delete 'cart/clear', to: 'shopping_cart#clear'
  
  # API routes
  namespace :api do
    namespace :v1 do
      resources :products, only: [:index, :show]
      resources :customizations, only: [:create, :show, :update, :destroy]
      resources :suppliers, only: [] do
        collection do
          post :sync_sanmar
          post :sync_ss_activewear
        end
      end
    end
  end
  
  # Admin routes (placeholder for future admin interface)
  namespace :admin do
    resources :stores
    resources :products
    resources :users
    resources :orders
  end
  
  # Sidekiq web interface (for development)
  if Rails.env.development?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA files
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
