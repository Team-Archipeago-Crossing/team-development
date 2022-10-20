Rails.application.routes.draw do

  root to: 'public/homes#top'
  get 'admin' => 'admin/homes#top'

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

  get "about" => "public/homes#about", as: "about"
  scope module: :public do
    resources :items, only: [:index, :show]
    resources :cart_items, only: [:create]
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post "confirm"
        get "confirm"
        get "complete"
      end
    end
  end
  
  namespace :admin do
    resources :customers, only: [:index, :edit, :show, :update]
  end

  scope module: :public do
    get 'customers'=>'customers#show'
    get 'customers/informetion/edit'=>'customers#edit'
    patch 'customers/informetion'=>'customers#update'
    get 'customers/disable_confirm'=>'customers#disable_confirm'
    patch 'customers/disable'
    resources :addresses, only: [:index,:edit,:create,:update,:destroy]
    resources :genres, only: [:show]
end

  # 管理者用
  namespace :admin do
    resources :items, except: [:destroy]
  end

  namespace :admin do
    resources :genres, only: [:index,:edit,:create,:update]
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end