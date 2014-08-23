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

ActiveRecord::Schema.define(version: 20140823132328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "clubs", force: true do |t|
    t.string   "name",       limit: 64, null: false
    t.string   "short_name", limit: 3,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", force: true do |t|
    t.string   "subject"
    t.integer  "recipient_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "conversations", ["creator_id"], name: "index_conversations_on_creator_id", using: :btree
  add_index "conversations", ["deleted_at"], name: "index_conversations_on_deleted_at", using: :btree
  add_index "conversations", ["recipient_id"], name: "index_conversations_on_recipient_id", using: :btree

  create_table "fixture_players", force: true do |t|
    t.integer "fixture_id"
    t.integer "player_id"
    t.integer "pld"
    t.integer "gls"
    t.integer "ass"
    t.integer "cs"
    t.integer "ga"
    t.integer "tot"
    t.boolean "red_card"
    t.boolean "yellow_card"
    t.boolean "full_game"
    t.boolean "subbed_off"
    t.boolean "subbed_on"
  end

  add_index "fixture_players", ["fixture_id"], name: "index_fixture_players_on_fixture_id", using: :btree
  add_index "fixture_players", ["player_id"], name: "index_fixture_players_on_player_id", using: :btree

  create_table "fixtures", force: true do |t|
    t.integer  "home_club_id", null: false
    t.integer  "away_club_id", null: false
    t.integer  "home_score"
    t.integer  "away_score"
    t.date     "date",         null: false
    t.time     "time",         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fixtures", ["away_club_id"], name: "index_fixtures_on_away_club_id", using: :btree
  add_index "fixtures", ["home_club_id", "away_club_id", "date"], name: "index_fixtures_on_home_club_id_and_away_club_id_and_date", unique: true, using: :btree
  add_index "fixtures", ["home_club_id"], name: "index_fixtures_on_home_club_id", using: :btree

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
    t.string   "mobile_number"
  end

  add_index "managers", ["approved"], name: "index_managers_on_approved", using: :btree
  add_index "managers", ["email"], name: "index_managers_on_email", unique: true, using: :btree
  add_index "managers", ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true, using: :btree

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "manager_id"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["manager_id"], name: "index_messages_on_manager_id", using: :btree

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
    t.string   "short_name",   limit: 64,                 null: false
    t.string   "full_name",    limit: 64,                 null: false
    t.string   "image",                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_new",                  default: false, null: false
    t.integer  "club_id"
    t.datetime "deleted_at"
    t.integer  "position",     limit: 2
    t.string   "status"
    t.string   "status_notes"
  end

  add_index "players", ["club_id"], name: "index_players_on_club_id", using: :btree
  add_index "players", ["deleted_at"], name: "index_players_on_deleted_at", using: :btree
  add_index "players", ["full_name"], name: "index_players_on_full_name", unique: true, using: :btree
  add_index "players", ["short_name"], name: "index_players_on_short_name", using: :btree

  create_table "sealed_bids", force: true do |t|
    t.integer  "player_id"
    t.integer  "manager_id"
    t.decimal  "bid",        precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "sealed_bids", ["deleted_at"], name: "index_sealed_bids_on_deleted_at", using: :btree
  add_index "sealed_bids", ["manager_id"], name: "index_sealed_bids_on_manager_id", using: :btree
  add_index "sealed_bids", ["player_id"], name: "index_sealed_bids_on_player_id", using: :btree

  create_table "team_months", force: true do |t|
    t.integer  "season"
    t.integer  "month"
    t.date     "month_beginning"
    t.integer  "team_id"
    t.integer  "gls"
    t.integer  "ass"
    t.integer  "cs"
    t.integer  "ga"
    t.integer  "tot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_months", ["team_id"], name: "index_team_months_on_team_id", using: :btree

  create_table "team_players", force: true do |t|
    t.boolean  "substitute",                             default: true,  null: false
    t.decimal  "purchase_price", precision: 5, scale: 2
    t.integer  "player_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.boolean  "starting",                               default: false, null: false
  end

  add_index "team_players", ["deleted_at"], name: "index_team_players_on_deleted_at", using: :btree
  add_index "team_players", ["player_id", "team_id"], name: "index_team_players_on_player_id_and_team_id", using: :btree
  add_index "team_players", ["starting"], name: "index_team_players_on_starting", using: :btree

  create_table "team_seasons", force: true do |t|
    t.integer  "season"
    t.integer  "team_id"
    t.integer  "gls"
    t.integer  "ass"
    t.integer  "cs"
    t.integer  "ga"
    t.integer  "tot"
    t.integer  "red_cards"
    t.integer  "yellow_cards"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_seasons", ["season"], name: "index_team_seasons_on_season", using: :btree
  add_index "team_seasons", ["team_id"], name: "index_team_seasons_on_team_id", using: :btree

  create_table "team_sheets", force: true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_sheets", ["player_id"], name: "index_team_sheets_on_player_id", using: :btree
  add_index "team_sheets", ["team_id"], name: "index_team_sheets_on_team_id", using: :btree

  create_table "team_weeks", force: true do |t|
    t.integer  "season"
    t.integer  "week"
    t.date     "week_beginning"
    t.integer  "team_id"
    t.integer  "gls"
    t.integer  "ass"
    t.integer  "cs"
    t.integer  "ga"
    t.integer  "tot"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_weeks", ["team_id"], name: "index_team_weeks_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name",                               null: false
    t.integer  "manager_id"
    t.decimal  "budget",     precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", unique: true, using: :btree

  create_table "watches", force: true do |t|
    t.integer  "player_id"
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
