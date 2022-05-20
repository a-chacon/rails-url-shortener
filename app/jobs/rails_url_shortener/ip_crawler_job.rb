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
        if Ipgeo.find_by(ip: visit.ip).updated_at <= 3.months.ago
          # Then update
          ip = HTTP.get("http://ip-api.com/json/#{visit.ip}?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query")
          if ip.code == 200
            ipgeo.update(JSON.parse(ip.body).transform_keys { |key| key.to_s.underscore }.slice(*Ipgeo.column_names))
            visit.update(ipgeo: ipgeo)
          end
        else
          visit.update(ipgeo: ipgeo)
        end
      elsif !Ipgeo.exists?(ip: visit.ip)
        # Then create a new record
        ip = HTTP.get("http://ip-api.com/json/#{visit.ip}?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query")
        if ip.code == 200
          ipgeo = Ipgeo.new(JSON.parse(ip.body).transform_keys { |key| key.to_s.underscore }.slice(*Ipgeo.column_names))
          ipgeo.ip = JSON.parse(ip.body)['query']
          ipgeo.save
          visit.update(ipgeo: ipgeo)
        end
      end
    rescue StandarError => e
      Rails.logger.debug { "Error#{e}" }
    end
  end
end
