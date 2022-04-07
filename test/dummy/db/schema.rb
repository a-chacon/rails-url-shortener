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

ActiveRecord::Schema[7.0].define(version: 2022_04_07_202539) do
  create_table "rails_url_shortener_urls", force: :cascade do |t|
    t.string "owner_type"
    t.integer "owner_id"
    t.text "url", null: false
    t.string "key", limit: 10, null: false
    t.string "category"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_type", "owner_id"], name: "index_rails_url_shortener_urls_on_owner"
  end

  create_table "rails_url_shortener_visits", force: :cascade do |t|
    t.integer "url_id"
    t.string "ip"
    t.string "user_agent"
    t.text "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_id"], name: "index_rails_url_shortener_visits_on_url_id"
  end

end
