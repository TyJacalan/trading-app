Rails.application.routes.draw do
  root 'pages#index'

  devise_scope :user do
    get 'admin/sign_in', to: 'admin/sessions#new'
    post 'admin/sign_in', to: 'admin/sessions#create'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

  resources :admins, only: [:index]
  namespace :admin do
    resources :users, except: %i[new edit]
    resources :transactions, only: %i[index]
  end

  namespace :users do
    patch :approvals, to: 'approvals#update'
    patch :roles, to: 'roles#update'
    get :lists, to: 'lists#show'
    get :search, to: 'search#show'
  end

  get :home, to: 'stocks#index'
  resources :stocks, only: %i[ show]
  
  resources :portfolios, only: %i[index show]
  resources :transactions, only: %i[index new create]
  resources :wallets, only: %i[index create]
  get :stocks_articles, to: 'stocks_articles#show'
  get :stocks_tables, to: 'stocks_tables#show'
  get :stocks_search, to: 'stocks_search#show'
  get :stocks_details, to: 'stocks_details#show'

  namespace :transactions do
    get :search, to: 'search#show'
  end

  # Error routes
  get '/404', to: 'errors#not_found', via: :all
  get '/403', to: 'errors#forbidden', via: :all
  get '/422', to: 'errors#unprocessable', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all
end
