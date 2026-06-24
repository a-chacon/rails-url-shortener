class CreateRailsUrlShortenerIpgeos < ActiveRecord::Migration[7.0]
  def up
    # Skip this migration by default - only run if IP geocoding is enabled via environment variable
    # Note: Set ENABLE_IP_GEOCODE=true before running migrations to create IP geocode tables
    unless ENV['ENABLE_IP_GEOCODE'] == 'true'
      say 'Skipping IP geocode migration (IP geocoding is disabled by default. Set ENABLE_IP_GEOCODE=true to enable)'
      return
    end

    # Check if table already exists (for idempotency)
    unless table_exists?(:rails_url_shortener_ipgeos)
      create_table :rails_url_shortener_ipgeos do |t|
        t.string  :ip
        t.string  :country
        t.string  :country_code
        t.string  :region
        t.string  :region_name
        t.string  :city
        t.string  :lat
        t.string  :lon
        t.string  :timezone
        t.string  :isp
        t.string  :org
        t.string  :as
        t.boolean :mobile
        t.boolean :proxy
        t.boolean :hosting
        t.timestamps
      end
    end

    # Check if column already exists before adding it
    unless column_exists?(:rails_url_shortener_visits, :ipgeo_id)
      add_column :rails_url_shortener_visits, :ipgeo_id, :integer
    end

    # Add index if it doesn't exist
    unless index_exists?(:rails_url_shortener_visits, :ipgeo_id)
      add_index :rails_url_shortener_visits, :ipgeo_id
    end
  end

  def down
    # Skip this migration if IP geocoding was never enabled
    return unless ENV['ENABLE_IP_GEOCODE'] == 'true'

    # Only drop if tables/columns exist
    if column_exists?(:rails_url_shortener_visits, :ipgeo_id)
      remove_column :rails_url_shortener_visits, :ipgeo_id
    end

    if table_exists?(:rails_url_shortener_ipgeos)
      drop_table :rails_url_shortener_ipgeos
    end
  end
end
