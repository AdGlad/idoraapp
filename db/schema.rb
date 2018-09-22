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

ActiveRecord::Schema.define(version: 2018_09_22_032106) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "article_categories", force: :cascade do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "picture"
    t.date "dob"
    t.string "team"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "face_id"
    t.string "external_image_id"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "image_identities", force: :cascade do |t|
    t.integer "image_id"
    t.integer "identity_id"
  end

  create_table "image_tags", force: :cascade do |t|
    t.integer "image_id"
    t.integer "tag_id"
  end

  create_table "imagematches", force: :cascade do |t|
    t.string "name"
    t.string "desc"
    t.string "resp"
    t.bigint "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["image_id"], name: "index_imagematches_on_image_id"
  end

  create_table "images", force: :cascade do |t|
    t.string "name"
    t.string "picture"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "matchid"
    t.string "facematchdetails"
    t.string "faces_matched"
    t.string "scene_matched"
    t.string "matchid1"
    t.string "matchid2"
    t.string "matchid3"
    t.string "matchid4"
    t.string "celebrity"
    t.index ["user_id"], name: "index_images_on_user_id"
  end

  create_table "labels", force: :cascade do |t|
    t.integer "image_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string "email"
    t.string "token"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "tag_type"
    t.string "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access"
    t.string "collectionid"
    t.uuid "unique_id", default: -> { "uuid_generate_v4()" }
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "uuid_extensions", force: :cascade do |t|
  end

  add_foreign_key "identities", "users"
  add_foreign_key "imagematches", "images"
  add_foreign_key "images", "users"
end
