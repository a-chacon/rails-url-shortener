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
      if Ipgeo.exists?(ip: visit.ip) && Ipgeo.find_by(ip: visit.ip).updated_at <= Time.now - 3.months
        # Then update
        ip = HTTP.get("http://ip-api.com/json/#{visit.ip}?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query")
        if ip.code == 200
          ipgeo = Ipgeo.find_by(ip: visit.ip)
          ipgeo.update(JSON.parse(ip.body).transform_keys { |key| key.to_s.underscore }.slice(*Ipgeo.column_names))
          visit.ipgeo = ipgeo
        end
      elsif !Ipgeo.exists?(ip: visit.ip)
        # Then create a new record
        ip = HTTP.get("http://ip-api.com/json/#{visit.ip}?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query")
        if ip.code == 200
          ipgeo = Ipgeo.new(JSON.parse(ip.body).transform_keys { |key| key.to_s.underscore }.slice(*Ipgeo.column_names))
          ipgeo.ip = JSON.parse(ip.body)['query']
          ipgeo.save
          visit.ipgeo = ipgeo
        end
      end
    rescue Exception => e
      print('Error' + e.to_s)
    end
  end
end
