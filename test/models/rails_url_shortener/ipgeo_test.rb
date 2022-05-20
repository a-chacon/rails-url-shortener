require 'test_helper'

module RailsUrlShortener
  class IpgeoTest < ActiveSupport::TestCase
    test 'create' do
      ipgeo = Ipgeo.new(ip: '12.12.12.12', country: 'Chile', country_code: 'CL', lat: '12,2,3')
      assert ipgeo.save
      ipgeo.visits << [rails_url_shortener_visits(:one_one), rails_url_shortener_visits(:one_two)]
      assert_equal 2, ipgeo.visits.count
    end
  end
end
