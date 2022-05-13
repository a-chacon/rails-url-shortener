require 'test_helper'

module RailsUrlShortener
  class UrlsHelperTest < ActionView::TestCase
    test 'generate url' do
      url = 'https://www.github.com/a-chacon/rails_url_shortener/asdss'
      assert_equal short_url(url), "http://test.host/shortener/#{Url.where(url: url).first.key}"
    end

    test 'generate with existing key' do
      url = 'https://www.github.com/a-chacon/rails_url_shortener/asdss'
      assert_equal short_url(url, key: 'aE1122'), url
    end

    test 'generate url with owner' do
      url = 'https://www.github.com/a-chacon/rails_url_shortener/asdss'
      assert_equal short_url(url, owner: users(:one)), "http://test.host/shortener/#{Url.where(url: url).first.key}"
      assert_equal Url.where(url: url).first.owner, users(:one)
    end

    test 'generate url with custom key' do
      url = 'https://www.github.com/a-chacon/rails_url_shortener/asdss'
      assert_equal short_url(url, key: 'asd'), "http://test.host/shortener/#{Url.where(url: url).first.key}"
    end

    test 'generate url with expires at' do
      url = 'https://www.github.com/a-chacon/rails_url_shortener/asdss'
      assert_equal short_url(url, expires_at: Time.now + 2.hours),
                   "http://test.host/shortener/#{Url.where(url: url).first.key}"
      assert_equal Url.where(url: url).first.expires_at.utc.ceil, (Time.now.utc + 2.hours).ceil
    end

    test 'generate url with category' do
      url = 'https://www.github.com/a-chacon/rails_url_shortener/asdss'
      assert_equal short_url(url, category: 'free'), "http://test.host/shortener/#{Url.where(url: url).first.key}"
      assert_equal Url.where(url: url).first.category, 'free'
    end
  end
end
