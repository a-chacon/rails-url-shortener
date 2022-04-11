module RailsUrlShortener
  require 'json'
  class Visit < ApplicationRecord

    belongs_to :url

    ##
    # Parse a request information and save
    #
    # Return true or validation errors

    def self.parse_and_save(url, request)
      # replace some invalid characters
      heads = request.headers.map{|k| k.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?')}.join
      # browser detection
      browser = Browser.new(request.headers["User-Agent"])
      # save
      Visit.create!(
        url: url,
        ip: request.ip,
        browser: browser.name,
        browser_version: browser.full_version,
        platform: browser.platform.name,
        platform_version: browser.platform.version,
        user_agent: request.headers["User-Agent"],
        meta: heads.to_json
      )
    end
  end
end
