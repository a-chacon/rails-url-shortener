require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test 'has short urls' do
    @user.urls << rails_url_shortener_urls(:one)
    assert_equal 1, @user.urls.count
  end
end
