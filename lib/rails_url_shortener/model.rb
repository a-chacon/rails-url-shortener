module RailsUrlShortener
  module Model
    # rubocop:disable Naming/PredicateName
    def has_short_urls
      class_eval do
        has_many :urls, class_name: 'RailsUrlShortener::Url', as: 'owner'
      end
    end
    # rubocop:enable Naming/PredicateName
  end
end
