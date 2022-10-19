Rails.application.routes.draw do
  root to: 'homes#top'

   # 顧客用
  # URL /customers/sign_in ...
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  # 管理者用
  # URL /admin/sign_in ...
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  get "about" => "homes#about", as: "about"
  resources :items, only: [:index, :show]
  resources :cart_items, only: [:create]
  resources :orders, only: [:new, :create] do
    collection do
      post "confirm"
      get "confirm"
      get "complete"
    end
  end
  

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