# frozen_string_literal: true

require 'rails/generators'

class RailsUrlShortenerGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  def install_and_run_migrations
    if Rails.env.test?
      puts 'Skipping migrations in test environment'
    else
      rake 'rails_url_shortener:install:migrations'
      rake 'db:migrate'
    end
  end

  def add_route_to_routes_file
    # Mount the engine at the bottom of the routes file in the host application.
    inject_into_file 'config/routes.rb', before: /\nend\s*\Z/ do
      "\n  mount RailsUrlShortener::Engine, at: '/'"
    end
  end

  def copy
    copy_file 'initializer.rb', 'config/initializers/rails_url_shortener.rb'
  end
end
