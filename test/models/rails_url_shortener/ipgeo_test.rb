# == Schema Information
#
# Table name: rails_url_shortener_ipgeos
#
#  id           :integer          not null, primary key
#  as           :string
#  city         :string
#  country      :string
#  country_code :string
#  hosting      :boolean
#  ip           :string
#  isp          :string
#  lat          :string
#  lon          :string
#  mobile       :boolean
#  org          :string
#  proxy        :boolean
#  region       :string
#  region_name  :string
#  timezone     :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
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
      VCR.use_cassette("ip:#{ipgeo.ip}") do
        assert_equal 'Valparaiso', ipgeo.city
        ipgeo.update_from_remote
        assert_equal 'Santiago', ipgeo.city
      end
    end
  end
end
