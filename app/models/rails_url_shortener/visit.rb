module RailsUrlShortener
  class Visit < ApplicationRecord
    belongs_to :url
    def self.parse_and_save(request)
      print(request.user_agent)
    end
  end
end
