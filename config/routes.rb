Rails.application.routes.draw do
  root to: 'homes#top'
  devise_for :users
  
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
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
