require "test_helper"

module RailsUrlShortener
  class IpCrawlerJobTest < ActiveJob::TestCase
    require 'json'
    test "perform with a non existing ip" do
      stub_request(:get, "http://ip-api.com/json/24.48.0.1?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query").
      with(headers: {
        'Connection' => 'close',
        'Host' => 'ip-api.com',
        'User-Agent' => 'http.rb/5.0.4'
      }).
      to_return(status: 200, body: %Q({
        "query": "24.48.0.1",
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

      visit = Visit.create(ip: "24.48.0.1", url: rails_url_shortener_urls(:one))

      assert_difference("Ipgeo.count") do
        IpCrawlerJob.perform_now(visit)
        assert visit.ipgeo
        assert_equal visit.ipgeo.ip, visit.ip
      end
    end

    test "perform with an existing ip less than 3 months" do
      stub_request(:get, "http://ip-api.com/json/66.90.76.179?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query").
      with(headers: {
        'Connection' => 'close',
        'Host' => 'ip-api.com',
        'User-Agent' => 'http.rb/5.0.4'
      }).
      to_return(status: 200, body: %Q({
        "query": "66.90.76.179",
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

      visit = rails_url_shortener_visits(:one_one)
      visit.update(ip: "66.90.76.179")

      assert_no_difference("Ipgeo.count") do
        IpCrawlerJob.perform_now(visit)
        assert visit.ipgeo
        assert_equal visit.ipgeo.ip, visit.ip
        assert_equal "chile", visit.ipgeo.country
      end
    end

    test "perform with an existing ip but older than 3 months" do
      stub_request(:get, "http://ip-api.com/json/66.90.76.179?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query").
      with(headers: {
        'Connection' => 'close',
        'Host' => 'ip-api.com',
        'User-Agent' => 'http.rb/5.0.4'
      }).
      to_return(status: 200, body: %Q({
        "query": "66.90.76.179",
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
      # prepare visit
      visit = rails_url_shortener_visits(:one_one)
      visit.update(ip: "66.90.76.179")
      # set a older updated at value
      ipgeo = rails_url_shortener_ipgeos(:one)
      ipgeo.update_columns(updated_at: Time.now - 4.months)

      assert_no_difference("Ipgeo.count") do
        IpCrawlerJob.perform_now(visit)
        assert visit.ipgeo
        assert_equal visit.ipgeo.ip, visit.ip
        assert_equal "Canada", visit.ipgeo.country
      end
    end
  end
end
