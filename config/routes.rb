Rails.application.routes.draw do
  root 'time_entries#index'
  resources :time_entries do
    get 'weekly', on: :collection
  end
  resources :sessions

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: "sessions#destroy", as: :signout
end
