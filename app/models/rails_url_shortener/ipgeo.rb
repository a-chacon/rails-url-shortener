# frozen_string_literal: true

module RailsUrlShortener
  class Ipgeo < ApplicationRecord
    has_many :visits
  end
end
