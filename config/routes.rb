Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"


  get 'files/:id', to: 'assets#show', as: :asset
  get 'files/:id/download', to: 'assets#download', as: :download_asset
end
