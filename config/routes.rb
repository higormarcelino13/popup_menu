Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  # namespace :api do
  #   namespace :v1 do
  #     resources :restaurants, only: [ :index, :show, :create, :destroy ]
  #     resources :menus, only: [ :show, :create, :destroy ]
  #     resources :menu_items, only: [ :show, :create, :destroy ]
  #   end
  # end
  post "/restaurants/create", to: "restaurant#create"
  post "/restaurants/bulk_create", to: "restaurant#bulk_create"
  get "/restaurants/show", to: "restaurant#index"
  delete "/restaurants/:id", to: "restaurant#destroy"
end
