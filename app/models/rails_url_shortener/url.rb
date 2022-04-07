module RailsUrlShortener
  class Url < ApplicationRecord
    has_many :visits
  end
end
