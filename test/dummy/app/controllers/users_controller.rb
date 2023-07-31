class UsersController < ApplicationController
  def new
    @shorted_url_in_controller_using_helper = short_url('https://a-chacon.com')
  end

  def show; end
end
