Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :kinds
  resources :auths, only: [:create]

  resources :contacts do
    resource :kind, only: [:show]
    resource :kind, only: [:show], path: 'relationships/kind'

    resources :phones, only: [:index, :destroy]
    resource :phone, only: [:create, :update]
    resources :phones, only: [:index, :destroy], path: 'relationships/phone'
    resource :phone, only: [:create, :update], path: 'relationships/phone'
    
    resource :address, only: [:show, :create, :update]
    resource :address, only: [:show, :create, :update], path: 'relationships/address'
  end
end
