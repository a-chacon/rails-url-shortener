# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_220_418_184_647) do
  create_table 'rails_url_shortener_ipgeos', force: :cascade do |t|
    t.string 'ip'
    t.string 'country'
    t.string 'country_code'
    t.string 'region'
    t.string 'region_name'
    t.string 'city'
    t.string 'lat'
    t.string 'lon'
    t.string 'timezone'
    t.string 'isp'
    t.string 'org'
    t.string 'as'
    t.boolean 'mobile'
    t.boolean 'proxy'
    t.boolean 'hosting'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'rails_url_shortener_urls', force: :cascade do |t|
    t.string 'owner_type'
    t.integer 'owner_id'
    t.text 'url', null: false
    t.string 'key', limit: 10, null: false
    t.string 'category'
    t.datetime 'expires_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index %w[owner_type owner_id], name: 'index_rails_url_shortener_urls_on_owner'
  end

  create_table 'rails_url_shortener_visits', force: :cascade do |t|
    t.integer 'url_id'
    t.string 'ip'
    t.string 'browser'
    t.string 'browser_version'
    t.string 'platform'
    t.string 'platform_version'
    t.boolean 'bot'
    t.string 'user_agent'
    t.text 'meta'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'ipgeo_id'
    t.index ['ipgeo_id'], name: 'index_rails_url_shortener_visits_on_ipgeo_id'
    t.index ['url_id'], name: 'index_rails_url_shortener_visits_on_url_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
