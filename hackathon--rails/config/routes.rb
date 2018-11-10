Rails.application.routes.draw do
  namespace :admin do
    get 'welcome', to: 'welcome#index'
  end

  root :to => redirect('/login')

  get 'login', to: 'users#login'
  post 'auth', to: 'users#auth'

  resources :users, except: [:index]
  get 'test', to: 'users#test' # JWT test for socket server
end
