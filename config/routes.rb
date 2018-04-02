Rails.application.routes.draw do
  resources :trips, only: [:index, :create]
  match 'trips_summary', to: 'trips#trips_summary', via: :get
end
