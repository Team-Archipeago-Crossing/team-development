Rails.application.routes.draw do

  root to: 'public/homes#top'

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
    resources :cart_items, only: [:index, :create, :update, :destroy] do
      collection do
        delete "destroy_all"
      end
    end
    resources :orders, only: [:new, :create, :index, :show] do
      collection do
        post "confirm"
        get "confirm"
        get "complete"
      end
    end
  end

  scope module: :public do
    get 'customers'=>'customers#show'
    get 'customers/information/edit'=>'customers#edit'
    patch 'customers/information'=>'customers#update'
    get 'customers/disable_confirm'=>'customers#disable_confirm'
    patch 'customers/disable'
    resources :addresses, only: [:index,:edit,:create,:update,:destroy]
    resources :genres, only: [:show]
  end

  namespace :admin do
    root to: 'homes#top'
    resources :customers, only: [:index, :edit, :show, :update]
    resources :orders, only: [:edit, :update]
    patch "/order_detail/:id" => "orders#update_detail", as: "order_detail"
    resources :items, except: [:destroy]
    resources :genres, only: [:index,:edit,:create,:update]
  end

  get "search" => "searches#search"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end