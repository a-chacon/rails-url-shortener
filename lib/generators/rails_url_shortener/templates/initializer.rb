# frozen_string_literal: true

CHARSETS = {
  alphanum: ('a'..'z').to_a + (0..9).to_a,
  alphacase: ('a'..'z').to_a + ('A'..'Z').to_a,
  alphanumcase: ('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a
}.freeze

RailsUrlShortener.host = ENV['HOST'] || 'localhost:3000' # the host used for the helper.
RailsUrlShortener.default_redirect = '/'            # where the users are redirect if the link is not found.
RailsUrlShortener.charset = CHARSETS[:alphanumcase] # used for generate the keys, better long.
RailsUrlShortener.key_length = 6                    # Key length for random generator
RailsUrlShortener.minimum_key_length = 3            # minimum permited for a key
RailsUrlShortener.save_bots_visits = false          # if save bots visits
RailsUrlShortener.save_visits = true                # if save visits
