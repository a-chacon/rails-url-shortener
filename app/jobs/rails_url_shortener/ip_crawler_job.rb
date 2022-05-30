# frozen_string_literal: true

module RailsUrlShortener
  class IpCrawlerJob < ApplicationJob
    queue_as :default

    require 'http'
    require 'json'

    ##
    # this function get the ip related data
    #
    # create or update an existing record information for an ip
    def perform(visit)
      if Ipgeo.exists?(ip: visit.ip)
        ipgeo = Ipgeo.find_by(ip: visit.ip)
        # update if older than three months
        ipgeo.update_from_remote if ipgeo.updated_at <= 3.months.ago
      elsif !Ipgeo.exists?(ip: visit.ip)
        # Then create a new record
        ipgeo = Ipgeo.create(ip: visit.ip)
        ipgeo.update_from_remote
      end
      visit.update(ipgeo: ipgeo) unless ipgeo.nil?
    end
  end
end
