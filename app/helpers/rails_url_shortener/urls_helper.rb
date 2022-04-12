module RailsUrlShortener
  module UrlsHelper
    def short_url(url, owner: nil, key: nil, expires_at: nil, category: nil, url_options: {})
      url_object = Url.generate(
        url,
        owner: owner,
        key: key,
        expires_at: expires_at,
        category: category
      )

      if url_object.errors.empty?
        # This must be fixed
        # the url_for helper must generate the url
        # options = {
        #   controller: "rails_url_shortener_url/urls",
        #   action: "show",
        #   key: url.key
        # }.merge(url_options)

        # url_for(options)
        rails_url_shortener_url + url_object.key
      else
        url
      end
    end
  end
end
