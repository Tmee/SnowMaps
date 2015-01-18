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

ActiveRecord::Schema.define(version: 20150117204156) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "privder"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "beever_creek_trails", force: true do |t|
    t.string   "name"
    t.string   "difficulty"
    t.integer  "peak_id"
    t.integer  "mountain_id", default: 6
    t.integer  "open",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "breckenridge_trails", force: true do |t|
    t.string   "name"
    t.string   "difficulty"
    t.integer  "peak_id"
    t.integer  "mountain_id", default: 2
    t.integer  "open",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keystone_trails", force: true do |t|
    t.string   "name"
    t.string   "difficulty"
    t.integer  "peak_id"
    t.integer  "mountain_id", default: 4
    t.integer  "open",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mountains", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "last_two_four"
    t.integer  "overnight"
    t.integer  "last_four_eight"
    t.integer  "last_seven_days"
    t.integer  "acres_open"
    t.integer  "acres_total"
    t.integer  "lifts_open"
    t.integer  "lifts_total"
    t.integer  "runs_open"
    t.integer  "runs_total"
    t.string   "snow_condition"
    t.integer  "base_depth"
    t.integer  "season_total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peaks", force: true do |t|
    t.string   "name"
    t.integer  "mountain_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trails", force: true do |t|
    t.string   "name"
    t.integer  "peak_id"
    t.string   "open"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "difficulty"
  end

  create_table "users", force: true do |t|
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vail_trails", force: true do |t|
    t.string   "name"
    t.string   "difficulty"
    t.integer  "peak_id"
    t.integer  "mountain_id", default: 1
    t.integer  "open",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
