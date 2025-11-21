require 'test_helper'
require 'generators/rails_url_shortener/rails_url_shortener_generator'

module RailsUrlShortener
  class RailsUrlShortenerGeneratorTest < Rails::Generators::TestCase
    tests RailsUrlShortenerGenerator
    destination Rails.root.join('tmp/generators')

    setup :prepare_destination

    test 'generator runs without errors' do
      assert_nothing_raised do
        # create config/routes.rb in tmp/generators 
        routes_file = File.join(destination_root, 'config', 'routes.rb')
        FileUtils.mkdir_p(File.dirname(routes_file))
        File.write(routes_file, "Rails.application.routes.draw do\nend")

        run_generator ['arguments']
      end

      # Verify initializer file is created at config/initializers/rails_url_shortener.rb
      assert_file 'config/initializers/rails_url_shortener.rb'

      # Verify correct entry is added to config/routes.rb
      assert_file 'config/routes.rb' do |content|
        assert_match(%r{mount RailsUrlShortener::Engine, at: '/}, content)
      end
    end

    test 'generator sets save_ip_geocode to false by default' do
      routes_file = File.join(destination_root, 'config', 'routes.rb')
      FileUtils.mkdir_p(File.dirname(routes_file))
      File.write(routes_file, "Rails.application.routes.draw do\nend")

      run_generator ['arguments']

      # Verify initializer has save_ip_geocode set to false
      assert_file 'config/initializers/rails_url_shortener.rb' do |content|
        assert_match(/RailsUrlShortener\.save_ip_geocode = false/, content)
      end
    end

    test 'generator sets save_ip_geocode to true when --enable-ip-geocode flag is used' do
      routes_file = File.join(destination_root, 'config', 'routes.rb')
      FileUtils.mkdir_p(File.dirname(routes_file))
      File.write(routes_file, "Rails.application.routes.draw do\nend")

      run_generator ['arguments', '--enable-ip-geocode']

      # Verify initializer has save_ip_geocode set to true
      assert_file 'config/initializers/rails_url_shortener.rb' do |content|
        assert_match(/RailsUrlShortener\.save_ip_geocode = true/, content)
        assert_no_match(/RailsUrlShortener\.save_ip_geocode = false/, content)
      end
    end

    test 'generator sets ENABLE_IP_GEOCODE environment variable when flag is used' do
      routes_file = File.join(destination_root, 'config', 'routes.rb')
      FileUtils.mkdir_p(File.dirname(routes_file))
      File.write(routes_file, "Rails.application.routes.draw do\nend")

      # Clear the env var first
      original_env = ENV['ENABLE_IP_GEOCODE']
      ENV.delete('ENABLE_IP_GEOCODE')

      run_generator ['arguments', '--enable-ip-geocode']

      # Verify environment variable was set
      assert_equal 'true', ENV['ENABLE_IP_GEOCODE']

      # Restore original value
      if original_env
        ENV['ENABLE_IP_GEOCODE'] = original_env
      else
        ENV.delete('ENABLE_IP_GEOCODE')
      end
    end
  end
end
