Rails.application.routes.draw do
  namespace :admin do
    get 'welcome', to: 'welcome#index'
  end

  root :to => redirect('/login')

  get 'login', to: 'users#login'
  get 'logout', to: 'users#logout'
  post 'auth', to: 'users#auth'

  resources :orders, only: [:new, :create, :show]
  get 'orders/:order_id/cancel', to: 'orders#cancel'

  resources :users, except: [:index]
  get 'test', to: 'users#test' # JWT test for socket server
end
