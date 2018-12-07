Rails.application.routes.draw do
  resources :img_signals
  resources :transactions
  resources :cards
  resources :clients
  post 'report', to: 'cards#report'
  post 'search', to: 'clients#show'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'clients#index'
end
