class CreateRailsUrlShortenerIpgeos < ActiveRecord::Migration[7.0]
  def up
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
    add_column :rails_url_shortener_visits, :ipgeo_id, :integer
    add_index :rails_url_shortener_visits, :ipgeo_id
  end

  def down
    remove_column :rails_url_shortener_visits, :ipgeo_id
    drop_table :rails_url_shortener_ipgeos
  end
end
