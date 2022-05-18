# frozen_string_literal: true

module RailsUrlShortener
  require 'json'
  class Visit < ApplicationRecord
    belongs_to :url
    belongs_to :ipgeo, optional: true

    ##
    # Parse a request information and save
    #
    # Return boolean

    def self.parse_and_save(url, request)
      # browser detection
      browser(request)
      if !RailsUrlShortener.save_bots_visits && @browser.bot?
        false
      else
        # save
        visit = Visit.create(
          url: url,
          ip: request.ip,
          browser: @browser.name,
          browser_version: @browser.full_version,
          platform: @browser.platform.name,
          platform_version: @browser.platform.version,
          bot: @browser.bot?,
          user_agent: request.headers['User-Agent']
        )
        # We enqueue a job for get more data later
        IpCrawlerJob.perform_later(visit)
        visit
      end
    end

    def self.browser(request)
      @browser = Browser.new(request.headers['User-Agent'])
    end
  end
end
