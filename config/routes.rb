Rails.application.routes.draw do
  resources :transactions
  resources :cards
  resources :clients
  post 'report', to: 'cards#report'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'clients#index'
end
