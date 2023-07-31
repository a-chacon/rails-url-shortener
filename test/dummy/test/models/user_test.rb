require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end
end
