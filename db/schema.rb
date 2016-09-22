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

ActiveRecord::Schema.define(version: 20160922033240) do

  create_table "avatar_stages", force: :cascade do |t|
    t.integer  "stage_id"
    t.integer  "avatar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_id"], name: "index_avatar_stages_on_avatar_id"
    t.index ["stage_id"], name: "index_avatar_stages_on_stage_id"
  end

  create_table "avatars", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "medium_id",  null: false
    t.string   "slug",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_avatars_on_deleted_at"
    t.index ["medium_id"], name: "index_avatars_on_medium_id"
    t.index ["slug"], name: "index_avatars_on_slug"
  end

  create_table "media", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "owner_id",   null: false
    t.string   "media_type", null: false
    t.datetime "deleted_at"
    t.string   "slug",       null: false
    t.string   "filename",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_media_on_deleted_at"
    t.index ["slug", "deleted_at"], name: "index_media_on_slug_and_deleted_at", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text     "content"
    t.string   "user_id"
    t.string   "integer"
    t.string   "stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "slug",       null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["name", "deleted_at"], name: "index_roles_on_name_and_deleted_at", unique: true
    t.index ["slug"], name: "index_roles_on_slug"
  end

  create_table "stage_media", force: :cascade do |t|
    t.integer  "stage_id"
    t.integer  "medium_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["medium_id"], name: "index_stage_media_on_medium_id"
    t.index ["stage_id"], name: "index_stage_media_on_stage_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id",   null: false
    t.datetime "deleted_at"
    t.string   "slug",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at", "slug"], name: "index_stages_on_deleted_at_and_slug", unique: true
    t.index ["deleted_at"], name: "index_stages_on_deleted_at"
    t.index ["slug"], name: "index_stages_on_slug"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                        null: false
    t.string   "password_digest",                              null: false
    t.string   "auth_token",                                   null: false
    t.string   "nickname",                                     null: false
    t.boolean  "is_active",              default: false,       null: false
    t.string   "slug",                                         null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.datetime "email_confirmed"
    t.string   "confirmation_token",     default: "CONFIRMED", null: false
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["deleted_at", "nickname"], name: "index_users_on_deleted_at_and_nickname", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["slug"], name: "index_users_on_slug"
  end

end
