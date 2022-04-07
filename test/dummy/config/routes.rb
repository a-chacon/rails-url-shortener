Rails.application.routes.draw do
  mount RailsUrlShortener::Engine => "/rails_url_shortener"
end
