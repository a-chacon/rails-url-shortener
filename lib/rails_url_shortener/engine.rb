# frozen_string_literal: true

module RailsUrlShortener
  class Engine < ::Rails::Engine
    isolate_namespace RailsUrlShortener
    require 'browser'
    require 'http'
  end
end
