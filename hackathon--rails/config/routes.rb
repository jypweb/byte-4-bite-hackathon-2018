Rails.application.routes.draw do
  namespace :admin do
    get 'welcome', to: 'welcome#index'
  end

  root :to => redirect('/login')

  get 'login', to: 'users#login'
  get 'logout', to: 'users#logout'
  post 'auth', to: 'users#auth'

  get 'orders/:order_id/cancel', to: 'orders#cancel', as: 'order_cancel'
  get 'orders/past_orders', to: 'orders#past_orders'
  resources :orders, only: [:new, :create, :show]

  resources :users, except: [:index]
  get 'test', to: 'users#test' # JWT test for socket server
end
