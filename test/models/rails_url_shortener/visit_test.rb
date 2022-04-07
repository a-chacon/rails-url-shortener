require 'test_helper'

module RailsUrlShortener
  class VisitTest < ActiveSupport::TestCase
    
    ##
    # Test basic of model visit
    #
    test 'create' do
      visit = Visit.new(
        url: rails_url_shortener_urls(:one),
        ip: '192.168.8.1',
        user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0',
        meta: 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0'
      )
      assert visit.save
      assert_equal visit.url, rails_url_shortener_urls(:one)
    end
  end
end
