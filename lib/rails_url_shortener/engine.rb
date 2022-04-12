module RailsUrlShortener
  class Engine < ::Rails::Engine
    isolate_namespace RailsUrlShortener
    require 'browser'
  end
end
