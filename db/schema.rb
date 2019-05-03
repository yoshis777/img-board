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

ActiveRecord::Schema.define(version: 20190205182341) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_histories", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_updated", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_name"
  end

  create_table "post_relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.bigint "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "images", array: true
    t.boolean "parent_flag", default: false
    t.string "password_digest"
    t.string "image_descriptions", array: true
    t.index ["topic_id"], name: "index_posts_on_topic_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "posts", "topics"
end
