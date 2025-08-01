# == Schema Information
#
# Table name: rails_url_shortener_visits
#
#  id               :integer          not null, primary key
#  bot              :boolean
#  browser          :string
#  browser_version  :string
#  ip               :string
#  meta             :text
#  platform         :string
#  platform_version :string
#  user_agent       :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  ipgeo_id         :integer
#  url_id           :integer
#
# Indexes
#
#  index_rails_url_shortener_visits_on_ipgeo_id  (ipgeo_id)
#  index_rails_url_shortener_visits_on_url_id    (url_id)
#
require 'test_helper'
require 'json'
module RailsUrlShortener
  class VisitTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper
    ##
    # Test basic of model visit
    #
    test 'create' do
      visit = Visit.new(
        url: rails_url_shortener_urls(:one),
        ip: '192.168.8.1',
        user_agent: 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0',
        meta: 'Mozilla/5.0 (X11; Linux x86_64; rv:89.0) Gecko/20100101 Firefox/89.0',
        referer: 'https://example.com'
      )
      assert visit.save
      assert_equal visit.url, rails_url_shortener_urls(:one)
    end

    test 'parse and save' do
      # generate a fake request
      request = ActionDispatch::TestRequest.create(env = Rack::MockRequest.env_for('/', 'HTTP_HOST' => 'test.host'.b,
                                                                                        'REMOTE_ADDR' => '1.0.0.0'.b, 'HTTP_USER_AGENT' => 'Rails Testing'.b,
                                                                                        'HTTP_REFERER' => 'https://example.com'.b))
      request.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1 Safari/605.1.15'
      # implement the method
      visit = nil
      assert_enqueued_with(job: IpCrawlerJob) do
        visit = Visit.parse_and_save(rails_url_shortener_urls(:one), request)
      end
      # asserts
      assert visit.user_agent, request.user_agent
      assert visit.ip, request.ip
      assert visit.url, rails_url_shortener_urls(:one)
      assert visit.browser, Browser.new(request.user_agent).name
      assert visit.browser_version, Browser.new(request.user_agent).full_version
      assert visit.platform, Browser.new(request.user_agent).platform.name
      assert visit.platform_version, Browser.new(request.user_agent).platform.version
      assert visit.referer, request.headers['Referer']
    end

    test "don't save bots" do
      # set the configuration
      RailsUrlShortener.save_bots_visits = false
      # generate a fake request
      request = ActionDispatch::TestRequest.create(env = Rack::MockRequest.env_for('/', 'HTTP_HOST' => 'test.host'.b,
                                                                                        'REMOTE_ADDR' => '1.0.0.0'.b, 'HTTP_USER_AGENT' => 'Rails Testing'.b))
      request.user_agent = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
      # asserts
      assert_no_enqueued_jobs do
        assert_not Visit.parse_and_save(rails_url_shortener_urls(:one), request)
      end

      RailsUrlShortener.save_bots_visits = true
    end

    test "don't save any" do
      # set the configuration
      RailsUrlShortener.save_visits = false

      # generate a fake request
      request = ActionDispatch::TestRequest.create(env = Rack::MockRequest.env_for('/', 'HTTP_HOST' => 'test.host'.b,
                                                                                        'REMOTE_ADDR' => '1.0.0.0'.b, 'HTTP_USER_AGENT' => 'Rails Testing'.b,
                                                                                        'HTTP_REFERER' => 'https://example.com'.b))
      request.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1 Safari/605.1.15'

      # asserts
      assert_no_enqueued_jobs do
        assert_not Visit.parse_and_save(rails_url_shortener_urls(:one), request)
      end

      RailsUrlShortener.save_visits = true
    end
  end
end
