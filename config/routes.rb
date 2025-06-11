Rails.application.routes.draw do
  devise_for :users
  
  # Root route
  root "home#index"
  
  # Product routes
  resources :products, only: [:index, :show] do
    member do
      get :customize
      post :save_customization
    end
  end
  
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
