RailsUrlShortener::Engine.routes.draw do
  get '/:key', to: 'urls#show'
end
