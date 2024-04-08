Rails.application.routes.draw do
  root 'stocks#index'
  devise_for :users

  resources :admins, only: [:index]
  namespace :admin do
    resources :users
    resources :transactions, only: %i[index show edit update]
  end

  resources :stocks, param: :symbol, only: %i[index show]
  resources :portfolios, only: %i[index show]
  resources :transactions, only: %i[index show]

  # Error routes
  get '/404', to: 'errors#not_found', via: :all
  get '/403', to: 'errors#forbidden', via: :all
  get '/422', to: 'errors#unprocessable', via: :all
  get '/500', to: 'errors#internal_server_error', via: :all
end
