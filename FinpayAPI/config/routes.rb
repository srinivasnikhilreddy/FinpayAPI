Rails.application.routes.draw do
  # PLATFORM AUTH
  devise_for :platform_users, # Devise sets internally: resource_class = PlatformUser
    path: 'platform',
    skip: [:registrations],
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      #registration: 'register'
    },
    controllers: {
      registrations: 'platform/registrations',
      sessions: 'platform/sessions'
    }

  namespace :platform do
    resources :companies, only: [:index, :show, :create, :destroy]
  end

  # TENANT AUTH
  devise_for :users,
    path: '',
    skip: [:registrations],
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      #registration: 'register'
    },
    controllers: {
      registrations: 'api/v1/users/registrations',
      sessions: 'api/v1/users/sessions'
    }

  namespace :api do
    namespace :v1 do
      resources :categories, only: [:index, :show, :create, :update, :destroy]
      resources :approvals do
        member do
          patch :approve
          patch :reject
        end
      end
      resources :accounts, only: [:index, :show, :create, :update, :destroy]
      resources :transactions, only: [:index, :show, :create, :destroy]
      resources :users, only: [:index, :show, :create, :update, :destroy]
      resources :audit_logs, only: [:index, :show]
      resources :expenses do
        member do
          patch :approve
          patch :reject
          patch :reimburse
          patch :archive
        end
        resources :receipts, only: [:index, :create]
      end
      resources :receipts, only: [:show, :update, :destroy]
    end
  end

  # Health check: usually load balancer will call /health
  # /health: It is a lightweight endpoint used by infrastructure components like load balancers and orchestration systems to verify service liveness and readiness.
  # In production, it can also validate database and cache connectivity.
  get '/health', to: 'health#check'
end


=begin
Ex - CRUD Routes:
----------------
Rails.application.routes.draw do
  # ...
  get "/products", to: "products#index"

  get "/products/new", to: "products#new"
  post "/products", to: "products#create"

  get "/products/:id", to: "products#show"

  get "/products/:id/edit", to: "products#edit"
  patch "/products/:id", to: "products#update" # partial update
  put "/products/:id", to: "products#update" # full update

  delete "/products/:id", to: "products#destroy"
end

Alternative - using Resource Routes:
-----------------------------------
Rails.application.routes.draw do
  # ...
  resources :products
end
=end