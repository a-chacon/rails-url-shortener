# frozen_string_literal: true

module RailsUrlShortener
  class Ipgeo < ApplicationRecord
    has_many :visits, dependent: :nullify
  end
end
