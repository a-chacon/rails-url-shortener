require 'test_helper'

module RailsUrlShortener
  class IpgeoTest < ActiveSupport::TestCase
    test 'create only with ip' do
      assert Ipgeo.create(ip: '13.13.13.13')
    end

    test 'create' do
      ipgeo = Ipgeo.new(ip: '12.12.12.12', country: 'Chile', country_code: 'CL', lat: '12,2,3')
      assert ipgeo.save
      ipgeo.visits << [rails_url_shortener_visits(:one_one), rails_url_shortener_visits(:one_two)]
      assert_equal 2, ipgeo.visits.count
    end

    test 'update from remote' do
      ipgeo = rails_url_shortener_ipgeos(:three)

      assert_equal 'Valparaiso', ipgeo.city
      VCR.use_cassette("ipgeo-#{ipgeo.ip}") do
        ipgeo.update_from_remote
      end
      assert_equal 'Santiago', ipgeo.city
    end
  end
end
