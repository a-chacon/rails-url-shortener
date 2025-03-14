# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in rails_url_shortener.gemspec.
gemspec

gem 'rails', '~> 7.0'

gem 'sqlite3'

gem 'sprockets-rails'

group :test do
  gem 'byebug'

  gem 'faker'

  gem 'webmock'

  gem 'vcr'
end

group :development, :test do
  gem 'rubocop', require: false

  gem 'minitest-cc'
end
