require 'test_helper'

module RailsUrlShortener
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers
    include ActiveJob::TestHelper

    test 'new' do
      get '/users/new'
      assert_response :ok
    end

    test 'create' do
      get '/users/1'
      assert_response :ok
    end
  end
end
