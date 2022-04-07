class CreateRailsUrlShortenerUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :rails_url_shortener_urls do |t|
      # optional if you can link it to a user or other model
      t.references :owner, polymorphic: true, null: true

      # the real url
      t.text :url, null: false, length: 2048

      # the unique key
      t.string :key, limit: 10, null: false

      # category for short url
      t.string :category

      # valid until date for expirable urls
      t.datetime :expires_at

      t.timestamps
    end
  end
end
