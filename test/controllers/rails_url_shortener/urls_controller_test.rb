require 'test_helper'

module RailsUrlShortener
  class UrlsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'show' do
      assert_difference 'Visit.count', 1 do
        get "/rails_url_shortener/#{rails_url_shortener_urls(:one).key}", headers: {
          user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0'
        }
        assert_response :moved_permanently
        assert_redirected_to rails_url_shortener_urls(:one).url
      end
    end

    test 'show whit a not existing key' do
      assert_no_difference 'Visit.count', 1 do
        get "/rails_url_shortener/noexist", headers: {
          user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0'
        }
        assert_response :moved_permanently
        assert_redirected_to RailsUrlShortener.default_redirect
      end
    end
  end
end
