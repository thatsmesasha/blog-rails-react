Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: { format: :json } do
    resources :posts, only: [ :index, :create, :destroy, :update, :show ] do
      get 'comments', on: :member
    end
    resources :comments, only: [ :create, :destroy, :update, :show ]
    resources :users, only: [ :create, :destroy, :update, :show ]
    get 'users/name/:name', to: 'users#name'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
