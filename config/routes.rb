Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  scope module: :public do
  get 'customers'=>'customers#show'
  get 'customers/edit'
  patch 'customers'=>'customers#update'
  get 'customers/disable_confirm'=>'customers#disable_confirm'
  patch 'customers/disable'
  resources :addresses, only: [:index,:edit,:create,:update,:destroy]
end
  resources :items, only: [:index, :show]
  


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
