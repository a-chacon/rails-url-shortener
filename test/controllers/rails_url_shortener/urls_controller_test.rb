require 'test_helper'

module RailsUrlShortener
  class UrlsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include ActiveJob::TestHelper

    test 'show' do
      assert_difference 'Visit.count', 1 do
        assert_enqueued_with(job: IpCrawlerJob) do
          get "/shortener/#{rails_url_shortener_urls(:one).key}", headers: {
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0'
          }
          assert_response :moved_permanently
          assert_redirected_to rails_url_shortener_urls(:one).url
        end
      end
    end

    test 'show whith a not existing key' do
      assert_no_difference 'Visit.count', 1 do
        assert_no_enqueued_jobs do
          get '/shortener/noexist', headers: {
            'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0'
          }
          assert_response :moved_permanently
          assert_redirected_to RailsUrlShortener.default_redirect
        end
      end
    end
  end
end
