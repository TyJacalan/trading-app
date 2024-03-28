Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  # Error routes
  get "/404", to: "errors#not_found", via: :all
  get "/403", to: "errors#forbidden", via: :all
  get "/422", to: "errors#unprocessable", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
end
