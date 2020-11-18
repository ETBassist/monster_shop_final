Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  resources :merchants do
    resources :items, only: [:index]
  end

  resources :items, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  get '/cart', to: 'cart#show'
  post '/cart/:item_id', to: 'cart#add_item'
  delete '/cart', to: 'cart#empty'
  patch '/cart/:change/:item_id', to: 'cart#update_quantity'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/registration', to: 'users#new', as: :registration
  resources :users, only: [:create, :update]
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

  namespace :merchant do
    get '/', to: 'dashboard#index', as: :dashboard
    get '/orders/:id', to: 'orders#show'
    get '/items', to: 'items#index'
    get '/items/new', to: 'items#new'
    post '/items', to: 'items#create'
    get '/items/:id/edit', to: 'items#edit'
    patch '/items/:id', to: 'items#update'
    put '/items/:id', to: 'items#update'
    delete '/items/:id', to: 'items#destroy'
    #resources :bulk_discounts
    get '/bulk_discounts', to: 'bulk_discounts#index'
    get '/bulk_discounts/new', to: 'bulk_discounts#new'
    get '/bulk_discounts/:id', to: 'bulk_discounts#show', as: :bulk_discount
    post '/bulk_discounts', to: 'bulk_discounts#create'
    get '/bulk_discounts/:id/edit', to: 'bulk_discounts#edit'
    patch '/bulk_discounts/:id', to: 'bulk_discounts#update'
    put '/bulk_discounts/:id', to: 'bulk_discounts#update'
    delete '/bulk_discounts/:id', to: 'bulk_discounts#destroy'
    put '/items/:id/change_status', to: 'items#change_status'
    get '/orders/:id/fulfill/:order_item_id', to: 'orders#fulfill'
  end

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
    resources :merchants, only: [:show, :update]
    resources :users, only: [:index, :show]
    patch '/orders/:id/ship', to: 'orders#ship'
  end
end
