Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'
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
