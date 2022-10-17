Rails.application.routes.draw do
  root to: 'homes#top'
  devise_for :users
  
  get "about" => "homes#about", as: "about"
  resources :items, only: [:index, :show]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
