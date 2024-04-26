Rails.application.routes.draw do
  root 'stocks#index'

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
    resources :user_roles, only: [:update]
    resources :approve_roles, only: [:update]
  end
  resources :stocks, only: %i[index show]
  resources :portfolios, only: %i[index show]
  resources :transactions, only: %i[index new create]
  get :stocks_articles, to: 'stocks_articles#show'
  get :stocks_tables, to: 'stocks_tables#show'
  get :stocks_search, to: 'stocks_search#show'
  get :stocks_details, to: 'stocks_details#show'
  get :home, to: 'pages#index'

  namespace :transactions do
    get :search, to: 'search#show'
  end

  # Error routes
  get '/404', to: 'errors#not_found', via: :all
  get '/403', to: 'errors#forbidden', via: :all
  get '/422', to: 'errors#unprocessable', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all
end
