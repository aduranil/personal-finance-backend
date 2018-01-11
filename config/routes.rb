Rails.application.routes.draw do
  resources :transactions
  resources :accounts
  resources :users
  resources :categories
  post '/login', to: 'auth#create'
  get '/current_user', to: 'auth#show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
