require 'test_helper'

module RailsUrlShortener
  class UrlTest < ActiveSupport::TestCase
    ##
    # Test basic of model url
    #
    test 'create' do
      url = Url.new(
        url: 'https://api.rubyonrails.org/v4.1.9/classes/Rails/Generators/Migration.html#method-i-migration_template',
        key: 'as12as',
        category: 'docs'
      )
      assert url.save
      url.visits << [rails_url_shortener_visits(:one_one), rails_url_shortener_visits(:one_two)]
      assert_equal url.visits.count, 2
    end

    test 'minimun validation key' do
      url = Url.new(
        url: 'https://api.rubyonrails.org/v4.1.9/classes/Rails/Generators/Migration.html#method-i-migration_template',
        key: 'AA',
        category: 'docs'
      )
      assert_not url.save
      assert_equal url.errors.first.attribute, :key
      assert_equal url.errors.first.type, :too_short
    end

    test 'valid url' do
      url = Url.new(
        url: 'htt://api.rubyonrails.org',
        key: 'AABB123',
        category: 'docs'
      )
      assert_not url.save
      assert_equal url.errors.first.attribute, :url
      url.url = 'https:://fuckgoogle.com'
      assert url.save
    end

    test 'find by key!' do
      assert_equal rails_url_shortener_urls(:one), Url.find_by_key!(rails_url_shortener_urls(:one).key)
    end

    test 'find by key' do
      assert_equal RailsUrlShortener.default_redirect, Url.find_by_key('not_exist').url
    end

    test 'basic generate key' do
      url = Url.generate('https://github.com/a-chacon/rails_url_shortener', expires_at: Time.now + 1.hour)
      assert url
      assert_equal url.key, Url.last.key
      assert_equal url.url, 'https://github.com/a-chacon/rails_url_shortener'
      assert_equal url.expires_at.utc.ceil, (Time.now.utc.ceil + 1.hour)
    end

    test 'custom key generate' do
      url = Url.generate('https://github.com/a-chacon/rails_url_shortener', key: 'asd123')
      assert url
      assert_equal url.key, 'asd123'
      assert_equal url.url, 'https://github.com/a-chacon/rails_url_shortener'
    end

    test 'custom key and user related' do
      url = Url.generate('https://github.com/a-chacon/rails_url_shortener', key: 'asd123', owner: users(:one))
      assert url
      assert_equal url.key, 'asd123'
      assert_equal url.url, 'https://github.com/a-chacon/rails_url_shortener'
      assert_equal url.owner, users(:one)
    end

    test 'error if the custom key exists' do
      url = Url.generate('https://github.com/a-chacon/rails_url_shortener', key: 'aE1111')
      assert_equal url.errors.first.attribute, :key
      assert_equal url.errors.first.type, :taken
    end
  end
end
