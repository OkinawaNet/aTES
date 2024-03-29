Rails.application.routes.draw do
  resources :tasks, only: [:index, :new, :create] do
    post :close, on: :member
  end
  post "assign_tasks" => "tasks#assign_tasks"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  post 'callbacks/keycloak_events', to: 'callbacks#keycloak_events'

  # Defines the root path route ("/")
  root :to => "tasks#index"
end
