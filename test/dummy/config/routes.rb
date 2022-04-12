Rails.application.routes.draw do
  mount RailsUrlShortener::Engine => "/"
end
