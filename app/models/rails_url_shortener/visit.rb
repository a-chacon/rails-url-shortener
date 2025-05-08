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
    # rubocop:disable Metrics/AbcSize
    def self.parse_and_save(url, request)
      browser(request)
      return false if !RailsUrlShortener.save_bots_visits && @browser.bot?

      visit = Visit.create(
        url: url,
        ip: request.ip,
        browser: @browser.name,
        browser_version: @browser.full_version,
        platform: @browser.platform.name,
        platform_version: @browser.platform.version,
        bot: @browser.bot?,
        user_agent: request.headers['User-Agent'],
        referer: request.headers['Referer']
      )

      IpCrawlerJob.perform_later(visit)
      visit
    end
    # rubocop:enable Metrics/AbcSize

    def self.browser(request)
      @browser = Browser.new(request.headers['User-Agent'])
    end
  end
end
