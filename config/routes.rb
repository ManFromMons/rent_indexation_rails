Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  get 'home/index'

  namespace :api, defaults: { format: :json, via:[:get, :post] } do
    namespace :v1 do
      get 'indexations', to: 'indexation#fetch_and_calculate'
      post 'indexations', to: 'indexation#fetch_and_calculate'
      match 'index', to: 'indexation#fetch_and_calculate', via: [:get, :post]
    end
  end
end
