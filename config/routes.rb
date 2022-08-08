Rails.application.routes.draw do
  resources :kinds
  resources :contacts do
    resource :kind, only: [:show]
    resource :kind, only: [:show], path: 'relationships/kind'

    resources :phones, only: [:index, :create, :update]
    resources :phones, only: [:index, :create, :update], path: 'relationships/phones'
    
    resource :address, only: [:show, :create, :update]
    resource :address, only: [:show, :create, :update], path: 'relationships/address'
  end
end
