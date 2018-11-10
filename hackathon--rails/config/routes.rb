Rails.application.routes.draw do
  namespace :admin do
    get 'welcome', to: 'welcome#index'
    get 'show_order_modal/:order_id', to: 'welcome#show_order', as: 'show_order'
    get 'cancel_order/:order_id', to: 'welcome#cancel_order', as: 'cancel_order'
    get 'order_update/:order_id', to: 'welcome#update_order', as: 'update_order'
    get 'refresh_order_list', to: 'welcome#refresh_orders', as: 'refresh_orders'
  end

  root :to => redirect('/login')

  get 'login', to: 'users#login'
  get 'logout', to: 'users#logout'
  post 'auth', to: 'users#auth'

  get 'orders/:order_id/cancel', to: 'orders#cancel', as: 'order_cancel'
  get 'orders/past_orders', to: 'orders#past_orders'
  resources :orders, only: [:new, :create, :show]

  get 'refresh_order_list', to: 'users#refresh_orders', as: 'refresh_orders'
  resources :users, except: [:index]
  get 'test', to: 'users#test' # JWT test for socket server
end
