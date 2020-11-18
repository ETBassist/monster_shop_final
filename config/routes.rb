Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  get '/merchants', to: 'merchants#index'
  get '/merchants/new', to: 'merchants#new'
  get '/merchants/:id', to: 'merchants#show', as: :merchant
  post '/merchants', to: 'merchants#create'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  put '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'
  get 'merchants/:merchant_id/items', to: 'items#index'

  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show', as: :item
  get 'items/:item_id/reviews/new', to: 'reviews#new', as: :new_item_review
  post 'items/:item_id/reviews', to: 'reviews#create', as: :item_reviews

  get '/reviews/:id/edit', to: 'reviews#edit', as: :edit_review
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy', as: :review

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration
  
  post 'users', to: 'users#create'
  patch 'users/:id', to: 'users#update'

  patch '/user/:id', to: 'users#update'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  get '/profile/edit_password', to: 'users#edit_password'
  post '/orders', to: 'user/orders#create'
  patch '/orders/:id', to: 'user/orders#update'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show'
  delete '/profile/orders/:id', to: 'user/orders#cancel'

  scope '/profile' do
    resources :addresses, except: :index
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#login'
  get '/logout', to: 'sessions#logout'

  get 'merchant/', to: 'merchant/dashboard#index', as: :merchant_dashboard
  get 'merchant/orders/:id', to: 'merchant/orders#show'
  get 'merchant/items', to: 'merchant/items#index'
  get 'merchant/items/new', to: 'merchant/items#new'
  post 'merchant/items', to: 'merchant/items#create'
  get 'merchant/items/:id/edit', to: 'merchant/items#edit'
  patch 'merchant/items/:id', to: 'merchant/items#update'
  put 'merchant/items/:id', to: 'merchant/items#update'
  delete 'merchant/items/:id', to: 'merchant/items#destroy'
  get 'merchant/bulk_discounts', to: 'merchant/bulk_discounts#index'
  get 'merchant/bulk_discounts/new', to: 'merchant/bulk_discounts#new'
  get 'merchant/bulk_discounts/:id', to: 'merchant/bulk_discounts#show', as: :merchant_bulk_discount
  post 'merchant/bulk_discounts', to: 'merchant/bulk_discounts#create'
  get 'merchant/bulk_discounts/:id/edit', to: 'merchant/bulk_discounts#edit'
  patch 'merchant/bulk_discounts/:id', to: 'merchant/bulk_discounts#update'
  put 'merchant/bulk_discounts/:id', to: 'merchant/bulk_discounts#update'
  delete 'merchant/bulk_discounts/:id', to: 'merchant/bulk_discounts#destroy'
  put 'merchant/items/:id/change_status', to: 'merchant/items#change_status'
  get 'merchant/orders/:id/fulfill/:order_item_id', to: 'merchant/orders#fulfill'

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show]
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
