# frozen_string_literal: true

require 'rails/generators'

class RailsUrlShortenerGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  # Add class option for IP geocoding flag
  class_option :enable_ip_geocode,
               type: :boolean,
               default: false,
               desc: 'Enable IP geocoding functionality and create ipgeos migration'

  def install_and_run_migrations
    if Rails.env.test?
      puts 'Skipping migrations in test environment'
    else
      # Set environment variable based on generator option
      if options[:enable_ip_geocode]
        ENV['ENABLE_IP_GEOCODE'] = 'true'
        puts 'Note: IP geocode migration will be created (--enable-ip-geocode flag)'
      else
        ENV['ENABLE_IP_GEOCODE'] = 'false' unless ENV['ENABLE_IP_GEOCODE']
        puts 'Note: IP geocode migration skipped. Use --enable-ip-geocode to enable it.'
      end
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

    # Update initializer if IP geocoding is enabled
    return unless options[:enable_ip_geocode]

    gsub_file 'config/initializers/rails_url_shortener.rb',
              /RailsUrlShortener\.save_ip_geocode = false/,
              'RailsUrlShortener.save_ip_geocode = true'
  end
end
