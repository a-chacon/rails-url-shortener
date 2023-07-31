Rails.application.routes.draw do
  mount RailsUrlShortener::Engine => '/shortener'
  resources :users, only: %i[new show]
end
