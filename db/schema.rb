# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150126220308) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arapahoe_basin_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "aspen_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beaver_creek_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "breckenridge_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "copper_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keystone_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loveland_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mountains", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "last_24"
    t.string   "overnight"
    t.string   "last_48"
    t.string   "last_7_days"
    t.string   "acres_open"
    t.string   "lifts_open"
    t.string   "runs_open"
    t.string   "snow_condition"
    t.integer  "base_depth"
    t.integer  "season_total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "town"
  end

  create_table "peaks", force: true do |t|
    t.string   "name"
    t.integer  "mountain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "powderhorn_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snowmass_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "telluride_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trails", force: true do |t|
    t.string   "name"
    t.string   "open"
    t.integer  "peak_id"
    t.integer  "mountain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "difficulty"
  end

  create_table "users", force: true do |t|
    t.string "name"
    t.string "uid"
    t.string "provider"
    t.string "profile_image_url"
    t.string "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vail_scrapers", force: true do |t|
    t.string   "name"
    t.string   "difficulty"
    t.integer  "peak_id"
    t.integer  "mountain_id"
    t.string   "open"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weather_reports", force: true do |t|
    t.string   "weekday"
    t.string   "icon"
    t.text     "conditions"
    t.integer  "mountain_id"
    t.string   "high"
    t.string   "low"
    t.string   "current_temp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weathers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "winter_park_scrapers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
