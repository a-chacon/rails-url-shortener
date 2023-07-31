# frozen_string_literal: true

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
module RailsUrlShortener
  class Ipgeo < ApplicationRecord
    has_many :visits, dependent: :nullify

    def update_from_remote
      @ip = HTTP.get("http://ip-api.com/json/#{ip}?fields=status,message,country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,mobile,proxy,hosting,query")
      return unless @ip.code == 200

      update(JSON.parse(@ip.body).transform_keys { |key| key.to_s.underscore }.slice(*Ipgeo.column_names))
    end
  end
end
