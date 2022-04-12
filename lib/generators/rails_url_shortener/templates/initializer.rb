RailsUrlShortener do |r|
  r.default_redirect = "/"
  r.charset = CHARSETS[:alphanumcase]
  r.key_length = 6
  r.minimum_key_length = 3
  r.save_bots_visits = false
end
