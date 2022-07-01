# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in rails_url_shortener.gemspec.
gemspec

gem 'rails', '>= 7.0.2.3'
gem 'sqlite3'

gem 'sprockets-rails'

group :test do
  gem 'byebug'
  gem 'faker', git: 'https://github.com/faker-ruby/faker.git', branch: 'master'
  gem 'webmock'
end

gem 'rubocop', require: false
gem 'rubocop-minitest', require: false
gem 'rubocop-rails', require: false

gem 'minitest-cc'
