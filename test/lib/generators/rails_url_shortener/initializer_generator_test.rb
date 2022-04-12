require "test_helper"
require "generators/rails_url_shortener/initializer_generator"

module RailsUrlShortener
  class InitializerGeneratorTest < Rails::Generators::TestCase
    tests InitializerGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    test "generator runs without errors" do
      assert_nothing_raised do
        run_generator ["arguments"]
      end
      assert_file "config/initializers/rails_url_shortener.rb"
    end
  end
end
