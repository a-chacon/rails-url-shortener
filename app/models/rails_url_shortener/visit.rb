# frozen_string_literal: true

# == Schema Information
#
# Table name: rails_url_shortener_visits
#
#  id               :integer          not null, primary key
#  bot              :boolean
#  browser          :string
#  browser_version  :string
#  ip               :string
#  meta             :text
#  platform         :string
#  platform_version :string
#  user_agent       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ipgeo_id         :integer
#  url_id           :integer
#
# Indexes
#
#  index_rails_url_shortener_visits_on_ipgeo_id  (ipgeo_id)
#  index_rails_url_shortener_visits_on_url_id    (url_id)
#
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
