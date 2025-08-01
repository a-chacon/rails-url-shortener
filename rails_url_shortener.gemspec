# frozen_string_literal: true

require_relative 'lib/rails_url_shortener/version'

Gem::Specification.new do |spec|
  spec.name        = 'rails_url_shortener'
  spec.version     = RailsUrlShortener::VERSION

  spec.authors     = ['a-chacon']
  spec.email       = ['andres.ch@protonmail.com']

  spec.homepage    = 'https://www.github.com/a-chacon/rails-url-shortener'
  spec.summary     = 'Rails url shortener engine.'
  spec.description = <<~DESC
    RailsUrlShortener is a lightweight Rails engine that enables easy creation and management of short URLs within your project.#{' '}
    Similar to bitly.com, it condenses long links into short, user-friendly addresses.#{' '}
    Enhance your app's functionality with this simple yet powerful URL shortening solution.
  DESC
  spec.license = 'GPL-3.0'

  spec.required_ruby_version = '>= 3.1'
  spec.required_rubygems_version = '>= 1.8.11'

  spec.metadata = {
    'bug_tracker_uri' => 'https://www.github.com/a-chacon/rails-url-shortener/issues',
    'changelog_uri' => "https://www.github.com/a-chacon/rails-url-shortener/releases/tag/v#{RailsUrlShortener::VERSION}",
    'documentation_uri' => 'https://github.com/a-chacon/rails-url-shortener/blob/main/README.md',
    'source_code_uri' => "https://github.com/a-chacon/rails-url-shortener/tree/v#{RailsUrlShortener::VERSION}",
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'browser', '>= 5.3.0'
  spec.add_dependency 'http', '>= 5.1.0'
end
