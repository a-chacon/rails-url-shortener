CHARSETS = {
  alphanum: ('a'..'z').to_a + (0..9).to_a,
  alphacase: ('a'..'z').to_a + ('A'..'Z').to_a,
  alphanumcase: ('A'..'Z').to_a + ('a'..'z').to_a  + (0..9).to_a
}

RailsUrlShortener.default_redirect = "/"
RailsUrlShortener.charset = CHARSETS[:alphanumcase]
RailsUrlShortener.key_length = 6
RailsUrlShortener.minimum_key_length = 3
RailsUrlShortener.save_bots_visits = false
