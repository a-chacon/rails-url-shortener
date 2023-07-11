require 'test_helper'

module RailsUrlShortener
  class IpCrawlerJobTest < ActiveJob::TestCase
    require 'json'
    test 'perform with a non existing ip' do
      VCR.use_cassette('ip:24.48.0.1') do
        visit = Visit.create(ip: '24.48.0.1', url: rails_url_shortener_urls(:one))

        assert_difference('Ipgeo.count') do
          IpCrawlerJob.perform_now(visit)
          assert visit.ipgeo
          assert_equal visit.ipgeo.ip, visit.ip
        end
      end
    end

    test 'perform with an existing ip less than 3 months' do
      VCR.use_cassette('ip:66.90.76.179') do
        visit = rails_url_shortener_visits(:one_one)
        visit.update(ip: '66.90.76.179')
        visit.ipgeo = nil

        assert_no_difference('Ipgeo.count') do
          IpCrawlerJob.perform_now(visit)
          assert visit.ipgeo
          assert_equal visit.ipgeo.ip, visit.ip
          assert_equal 'chile', visit.ipgeo.country
        end
      end
    end

    test 'perform with an existing ip but older than 3 months' do
      VCR.use_cassette('ip:66.90.76.179') do
        # prepare visit
        visit = rails_url_shortener_visits(:one_one)
        visit.update(ip: '66.90.76.179')
        visit.ipgeo = nil
        # set a older updated at value
        ipgeo = rails_url_shortener_ipgeos(:one)
        ipgeo.update_columns(updated_at: Time.now - 4.months)

        assert_no_difference('Ipgeo.count') do
          IpCrawlerJob.perform_now(visit)
          assert visit.ipgeo
          assert_equal visit.ipgeo.ip, visit.ip
          assert_equal 'Chile', visit.ipgeo.country
        end
      end
    end
  end
end
