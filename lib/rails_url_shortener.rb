# frozen_string_literal: true

require 'rails_url_shortener/version'
require 'rails_url_shortener/engine'
require 'rails_url_shortener/model'
require_relative '../app/helpers/rails_url_shortener/urls_helper'

module RailsUrlShortener
  ##
  # constants
  CHARSETS = {
    alphanum: ('a'..'z').to_a + (0..9).to_a,
    alphacase: ('a'..'z').to_a + ('A'..'Z').to_a,
    alphanumcase: ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a
  }.freeze

  ##
  # host for build final url on helper
  mattr_accessor :host, default: 'test.host'

  ##
  # default redirection url when the key isn't found
  mattr_accessor :default_redirect, default: '/'

  ##
  # charset for generate keys
  mattr_accessor :charset, default: CHARSETS[:alphanumcase]

  ##
  # default key length used by random keys
  mattr_accessor :key_length, default: 6

  ##
  # minimum key length for custom keys
  mattr_accessor :minimum_key_length, default: 3

  ##
  # if save bots visits on db, the detection is provided by browser gem
  # and is described like "The bot detection is quite aggressive"
  # so if you put this configuration like false could lose some visits to your link
  # by default saving all requests
  mattr_accessor :save_bots_visits, default: true

  mattr_accessor :save_visits, default: true
end

ActiveSupport.on_load(:active_record) do
  extend RailsUrlShortener::Model
end

ActiveSupport.on_load(:action_view) do
  prepend RailsUrlShortener::UrlsHelper
end

ActiveSupport.on_load(:action_controller_base) do
  prepend RailsUrlShortener::UrlsHelper
end
