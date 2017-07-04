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

ActiveRecord::Schema.define(version: 20170616074032) do

  create_table "agents", force: :cascade do |t|
    t.string   "name",            limit: 255,                        null: false
    t.string   "email",           limit: 255,                        null: false
    t.boolean  "is_admin",        limit: 1,   default: false
    t.string   "password_digest", limit: 255,                        null: false
    t.string   "status",          limit: 255, default: "registered", null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "agents", ["email"], name: "index_agents_on_email", using: :btree

  create_table "tickets", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                      null: false
    t.integer  "agent_id",   limit: 4
    t.string   "subject",    limit: 255,                    null: false
    t.string   "content",    limit: 255
    t.datetime "closed_on"
    t.string   "status",     limit: 255, default: "raised", null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "tickets", ["agent_id"], name: "index_tickets_on_agent_id", using: :btree
  add_index "tickets", ["user_id"], name: "index_tickets_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255,                    null: false
    t.string   "email",           limit: 255,                    null: false
    t.string   "password_digest", limit: 255,                    null: false
    t.string   "status",          limit: 255, default: "active", null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
