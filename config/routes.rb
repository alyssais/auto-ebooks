Rails.application.routes.draw do
  root to: 'accounts#new'
  get 'auth/twitter/callback' => 'accounts#create'
  get 'auth/failure' => redirect('/')
  resources :accounts, only: :update
end
