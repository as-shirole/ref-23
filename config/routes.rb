Rails.application.routes.draw do
  resources :posts
  root to: "home#index"

  # devise_for :users
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :home do
  	collection do
  		get :welcome
      post :store_locations
      get :check_out_places
      post :push_places
  	end
  end
end
