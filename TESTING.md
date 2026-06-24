# Testing Guide

This guide explains how to test the IP geocoding configuration feature.

## Running Automated Tests

### Run All Tests
```bash
bundle exec rake test
```

### Run Specific Test Files
```bash
# Test the generator with the flag
bundle exec ruby -Itest test/lib/generators/rails_url_shortener/rails_url_shortener_generator_test.rb

# Test the Visit model (includes IP geocoding tests)
bundle exec ruby -Itest test/models/rails_url_shortener/visit_test.rb

# Test the IP crawler job
bundle exec ruby -Itest test/jobs/rails_url_shortener/ip_crawler_job_test.rb
```

## Manual Testing

### 1. Test Generator Without Flag (Default - IP Geocoding Disabled)

```bash
# In a temporary Rails app or the test dummy app
cd test/dummy

# Run generator without flag
rails generate rails_url_shortener

# Verify the initializer has save_ip_geocode = false
cat config/initializers/rails_url_shortener.rb | grep save_ip_geocode
# Should show: RailsUrlShortener.save_ip_geocode = false

# Check that migration was skipped (ipgeos table should not exist)
rails db:migrate:status | grep ipgeo
# Should show the migration was skipped or not run

# Try to access the ipgeos table
rails console
> RailsUrlShortener::Ipgeo.table_exists?
# Should return: false (if migration was skipped)
```

### 2. Test Generator With Flag (IP Geocoding Enabled)

```bash
# Run generator with the flag
rails generate rails_url_shortener --enable-ip-geocode

# Verify the initializer has save_ip_geocode = true
cat config/initializers/rails_url_shortener.rb | grep save_ip_geocode
# Should show: RailsUrlShortener.save_ip_geocode = true

# Check that migration ran
rails db:migrate:status | grep ipgeo
# Should show the migration was executed

# Verify the ipgeos table exists
rails console
> RailsUrlShortener::Ipgeo.table_exists?
# Should return: true

> ActiveRecord::Base.connection.column_exists?(:rails_url_shortener_visits, :ipgeo_id)
# Should return: true
```

### 3. Test Runtime Behavior - IP Geocoding Disabled (Default)

```bash
rails console

# Verify default configuration
> RailsUrlShortener.save_ip_geocode
# Should return: false

# Create a visit (simulating a URL redirect)
> url = RailsUrlShortener::Url.generate('https://example.com')
> request = ActionDispatch::TestRequest.create
> request.remote_addr = '192.168.1.1'
> visit = RailsUrlShortener::Visit.parse_and_save(url, request)

# Verify visit was created but IpCrawlerJob was NOT enqueued
> visit.persisted?
# Should return: true

> ActiveJob::Base.queue_adapter.enqueued_jobs.select { |j| j[:job] == RailsUrlShortener::IpCrawlerJob }.count
# Should return: 0 (no job enqueued)

> visit.ipgeo
# Should return: nil
```

### 4. Test Runtime Behavior - IP Geocoding Enabled

```bash
rails console

# Enable IP geocoding
> RailsUrlShortener.save_ip_geocode = true

# Create a visit
> url = RailsUrlShortener::Url.generate('https://example.com')
> request = ActionDispatch::TestRequest.create
> request.remote_addr = '192.168.1.1'
> request.user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'

# Use ActiveJob test adapter to catch enqueued jobs
> ActiveJob::Base.queue_adapter = ActiveJob::QueueAdapters::TestAdapter.new

> visit = RailsUrlShortener::Visit.parse_and_save(url, request)

# Verify visit was created AND IpCrawlerJob was enqueued
> visit.persisted?
# Should return: true

> ActiveJob::Base.queue_adapter.enqueued_jobs.select { |j| j[:job] == RailsUrlShortener::IpCrawlerJob }.count
# Should return: 1 (job was enqueued)

# Process the job (if testing in test environment with VCR cassettes)
# > RailsUrlShortener::IpCrawlerJob.perform_now(visit)
```

### 5. Test Migration Behavior Directly

```bash
# Test that migration skips by default
ENV['ENABLE_IP_GEOCODE'] = nil
rails db:migrate:down VERSION=20220418184647 2>/dev/null || true
rails db:migrate:up VERSION=20220418184647
# Should output: "Skipping IP geocode migration..."

# Test that migration runs when flag is set
ENV['ENABLE_IP_GEOCODE'] = 'true'
rails db:migrate:down VERSION=20220418184647 2>/dev/null || true
rails db:migrate:up VERSION=20220418184647
# Should create the tables

# Verify tables exist
rails console
> RailsUrlShortener::Ipgeo.table_exists?
> ActiveRecord::Base.connection.column_exists?(:rails_url_shortener_visits, :ipgeo_id)
```

### 6. Integration Test - Full Workflow

```bash
# 1. Generate with flag
rails generate rails_url_shortener --enable-ip-geocode

# 2. Verify initializer
grep "save_ip_geocode = true" config/initializers/rails_url_shortener.rb

# 3. Start Rails server
rails server

# 4. In another terminal, create a short URL
rails console
> url = RailsUrlShortener::Url.generate('https://example.com')
> puts url.to_short_url

# 5. Visit the short URL
curl http://localhost:3000/shortener/[KEY]

# 6. Check that visit was created and IpCrawlerJob was enqueued
rails console
> visit = RailsUrlShortener::Visit.last
> visit.ipgeo  # Should have ipgeo if job completed
```

## Test Checklist

- [ ] Generator without flag creates initializer with `save_ip_geocode = false`
- [ ] Generator with `--enable-ip-geocode` creates initializer with `save_ip_geocode = true`
- [ ] Migration skips by default (no ipgeos table created)
- [ ] Migration runs when `ENABLE_IP_GEOCODE=true` is set
- [ ] Visit.parse_and_save does not enqueue IpCrawlerJob when disabled
- [ ] Visit.parse_and_save enqueues IpCrawlerJob when enabled
- [ ] All existing tests still pass
- [ ] New generator tests pass

