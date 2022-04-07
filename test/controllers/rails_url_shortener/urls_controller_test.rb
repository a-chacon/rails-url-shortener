require "test_helper"

module RailsUrlShortener
  class UrlsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "show" do
      get "/rails_url_shortener/as12as", headers:{
        user_agent: "Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0"
      }
      assert_response :moved_permanently
    end
  end
end
