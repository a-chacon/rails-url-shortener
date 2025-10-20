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
  end
end
