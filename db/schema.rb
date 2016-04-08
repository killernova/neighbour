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

ActiveRecord::Schema.define(version: 20160308082923) do

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "body",       limit: 65535,             null: false
    t.integer  "user_id",    limit: 4
    t.integer  "topic_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agree",      limit: 4,     default: 0
    t.integer  "disagree",   limit: 4,     default: 0
  end

  add_index "comments", ["topic_id"], name: "index_comments_on_topic_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  

  

  create_table "forums", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  add_index "forums", ["name"], name: "index_forums_on_name", unique: true, using: :btree

  create_table "photos", force: :cascade do |t|
    t.string   "image",        limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "name",         limit: 255
    t.string   "size",         limit: 255
    t.string   "content_type", limit: 255
    t.integer  "comment_id",   limit: 4
    t.integer  "topic_id",     limit: 4
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255,             null: false
    t.integer  "rate",       limit: 4,   default: 0
    t.string   "url",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",     limit: 255
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title",          limit: 255,               null: false
    t.text     "body",           limit: 65535,             null: false
    t.integer  "comments_count", limit: 4,     default: 0
    t.integer  "user_id",        limit: 4
    t.integer  "forum_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agree",          limit: 4,     default: 0
    t.integer  "disagree",       limit: 4,     default: 0
    t.integer  "recommend",      limit: 4
    t.string   "zh_title",       limit: 255
    t.string   "zh_body",        limit: 5000
    t.string   "en_title",       limit: 255
    t.string   "en_body",        limit: 5000
  end

  add_index "topics", ["forum_id"], name: "index_topics_on_forum_id", using: :btree
  add_index "topics", ["user_id"], name: "index_topics_on_user_id", using: :btree

  create_table "user_addresses", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "name",       limit: 45,  null: false
    t.string   "mobile",     limit: 45
    t.string   "address",    limit: 500, null: false
    t.string   "living_area",       limit: 255
    t.integer  "default",    limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_addresses", ["user_id"], name: "index_user_addresses_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",           limit: 255,               null: false
    t.string   "name",               limit: 255
    t.string   "mobile",             limit: 255,               null: false
    t.string   "sex",                limit: 1,   default: "0"
    t.string   "email",              limit: 255
    t.string   "password_digest",    limit: 255
    t.string   "role",               limit: 1,   default: "0"
    t.string   "avator",             limit: 500
    t.string   "profession",         limit: 45
    t.string   "location",           limit: 45
    t.string   "wexin_openid",       limit: 255
    t.integer  "comments_count",     limit: 4,   default: 0
    t.integer  "participants_count", limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname",           limit: 255
  end


  create_table "wechats", force: :cascade do |t|
    t.string   "auth_access_token",             limit: 255
    t.integer  "auth_access_token_expires_at",  limit: 4
    t.string   "auth_refresh_token",            limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "auth_refresh_token_expires_at", limit: 4
    t.string   "access_token",                  limit: 255
    t.integer  "access_token_expires_at",       limit: 4
    t.string   "jsapi_ticket",                  limit: 255
    t.integer  "jsapi_ticket_expires_at",       limit: 4
  end

end
