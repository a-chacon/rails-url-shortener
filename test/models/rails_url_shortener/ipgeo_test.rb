require 'test_helper'

module RailsUrlShortener
  class IpgeoTest < ActiveSupport::TestCase

    test 'create only with ip' do
        assert Ipgeo.create(ip:'13.13.13.13')
    end

    test 'create' do
      ipgeo = Ipgeo.new(ip: '12.12.12.12', country: 'Chile', country_code: 'CL', lat: '12,2,3')
      assert ipgeo.save
      ipgeo.visits << [rails_url_shortener_visits(:one_one), rails_url_shortener_visits(:one_two)]
      assert_equal 2, ipgeo.visits.count
    end

    test 'update from remote' do
        ipgeo = rails_url_shortener_ipgeos(:three)

        stub_request(:get, "http://ip-api.com/json/#{ipgeo.ip}?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query")
          .with(headers: {
                  'Connection' => 'close',
                  'Host' => 'ip-api.com',
                  'User-Agent' => 'http.rb/5.0.4'
                })
          .to_return(status: 200, body: %({
          "query": "#{ipgeo.ip}",
          "status": "success",
          "country": "Canada",
          "countryCode": "CA",
          "region": "QC",
          "regionName": "Quebec",
          "city": "Montreal",
          "zip": "H3G",
          "lat": 45.4995,
          "lon": -73.5848,
          "timezone": "America/Toronto",
          "isp": "Le Groupe Videotron Ltee",
          "org": "Videotron Ltee",
          "as": "AS5769 Videotron Telecom Ltee",
          "mobile": false,
          "proxy": false,
          "hosting": false
        }), headers: {})

        assert_equal "Valparaiso", ipgeo.city
        ipgeo.update_from_remote
        assert_equal "Montreal", ipgeo.city
    end
  end
end
