Rails.application.routes.draw do
  resources :trips, only: [:index, :create]
end
