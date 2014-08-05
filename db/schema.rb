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

ActiveRecord::Schema.define(version: 20140805200006) do

  create_table "fixtures", force: true do |t|
    t.string   "home_team",  limit: 32, null: false
    t.string   "away_team",  limit: 32, null: false
    t.integer  "home_score",            null: false
    t.integer  "away_score",            null: false
    t.date     "date",                  null: false
    t.time     "time",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fixtures", ["home_team", "away_team", "date"], name: "index_fixtures_on_home_team_and_away_team_and_date", unique: true, using: :btree

  create_table "fixtures_players", id: false, force: true do |t|
    t.integer "fixture_id", null: false
    t.integer "player_id",  null: false
    t.integer "pld"
    t.integer "gls"
    t.integer "ass"
    t.integer "cs"
    t.integer "ga"
    t.integer "tot"
  end

  add_index "fixtures_players", ["fixture_id", "player_id"], name: "index_fixtures_players_on_fixture_id_and_player_id", using: :btree

  create_table "managers", force: true do |t|
    t.string   "email",                             default: "",    null: false
    t.string   "encrypted_password",                default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "approved",                          default: false, null: false
    t.boolean  "admin",                             default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 64
  end

  add_index "managers", ["approved"], name: "index_managers_on_approved", using: :btree
  add_index "managers", ["email"], name: "index_managers_on_email", unique: true, using: :btree
  add_index "managers", ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true, using: :btree

  create_table "player_seasons", force: true do |t|
    t.integer  "season",                 null: false
    t.integer  "player_id",              null: false
    t.integer  "pld",        default: 0
    t.integer  "gls",        default: 0
    t.integer  "ass",        default: 0
    t.integer  "cs",         default: 0
    t.integer  "ga",         default: 0
    t.integer  "tot",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "player_seasons", ["season", "player_id"], name: "index_player_seasons_on_season_and_player_id", unique: true, using: :btree

  create_table "players", force: true do |t|
    t.string   "short_name", limit: 64, null: false
    t.string   "full_name",  limit: 64, null: false
    t.string   "club",       limit: 3,  null: false
    t.string   "position",   limit: 1,  null: false
    t.string   "image",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["full_name"], name: "index_players_on_full_name", unique: true, using: :btree
  add_index "players", ["short_name"], name: "index_players_on_short_name", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name",       null: false
    t.integer  "manager_id"
    t.integer  "budget"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true, using: :btree

end
