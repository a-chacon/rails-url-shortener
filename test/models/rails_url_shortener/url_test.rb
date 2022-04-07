require "test_helper"

module RailsUrlShortener
  class UrlTest < ActiveSupport::TestCase

    ##
    # Test basic of model url
    #
    test "create" do
      url = Url.new(
        url: "https://api.rubyonrails.org/v4.1.9/classes/Rails/Generators/Migration.html#method-i-migration_template",
        key: "as12as",
        category: "docs"
      )
      assert url.save
      url.visits << [rails_url_shortener_visits(:one), rails_url_shortener_visits(:two)]
      assert_equal url.visits.count, 2
    end
    
  end
end
