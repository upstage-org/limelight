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

ActiveRecord::Schema.define(version: 20170905075038) do

  create_table "announcements", force: :cascade do |t|
    t.string "title", null: false
    t.string "subtitle"
    t.text "body", null: false
    t.integer "user_id", null: false
    t.string "slug", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_announcements_on_deleted_at"
    t.index ["slug", "deleted_at"], name: "index_announcements_on_slug_and_deleted_at", unique: true
    t.index ["slug"], name: "index_announcements_on_slug"
    t.index ["user_id"], name: "index_announcements_on_user_id"
  end

  create_table "avatar_stages", force: :cascade do |t|
    t.integer "stage_id"
    t.integer "avatar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_id"], name: "index_avatar_stages_on_avatar_id"
    t.index ["stage_id"], name: "index_avatar_stages_on_stage_id"
  end

  create_table "avatar_tags", force: :cascade do |t|
    t.integer "avatar_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_id", "tag_id"], name: "index_avatar_tags_on_avatar_id_and_tag_id", unique: true
    t.index ["avatar_id"], name: "index_avatar_tags_on_avatar_id"
    t.index ["tag_id"], name: "index_avatar_tags_on_tag_id"
  end

  create_table "avatars", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_file_name"
    t.string "source_content_type"
    t.integer "source_file_size"
    t.datetime "source_updated_at"
    t.index ["deleted_at"], name: "index_avatars_on_deleted_at"
    t.index ["slug"], name: "index_avatars_on_slug"
  end

  create_table "backdrop_tags", force: :cascade do |t|
    t.integer "backdrop_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["backdrop_id", "tag_id"], name: "index_backdrop_tags_on_backdrop_id_and_tag_id", unique: true
    t.index ["backdrop_id"], name: "index_backdrop_tags_on_backdrop_id"
    t.index ["tag_id"], name: "index_backdrop_tags_on_tag_id"
  end

  create_table "backdrops", force: :cascade do |t|
    t.string "name", null: false
    t.integer "medium_id"
    t.datetime "deleted_at"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_file_name"
    t.string "source_content_type"
    t.integer "source_file_size"
    t.datetime "source_updated_at"
    t.index ["deleted_at"], name: "index_backdrops_on_deleted_at"
    t.index ["medium_id"], name: "index_backdrops_on_medium_id"
    t.index ["slug", "deleted_at"], name: "index_backdrops_on_slug_and_deleted_at", unique: true
    t.index ["slug"], name: "index_backdrops_on_slug"
  end

  create_table "media", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "filename", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_media_on_deleted_at"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.integer "sender_id"
    t.integer "stage_id"
    t.text "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message_type"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
    t.index ["stage_id"], name: "index_messages_on_stage_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
    t.index ["name", "deleted_at"], name: "index_roles_on_name_and_deleted_at", unique: true
    t.index ["slug"], name: "index_roles_on_slug"
  end

  create_table "sound_tags", force: :cascade do |t|
    t.integer "sound_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sound_id", "tag_id"], name: "index_sound_tags_on_sound_id_and_tag_id", unique: true
    t.index ["sound_id"], name: "index_sound_tags_on_sound_id"
    t.index ["tag_id"], name: "index_sound_tags_on_tag_id"
  end

  create_table "sounds", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source_file_name"
    t.string "source_content_type"
    t.integer "source_file_size"
    t.datetime "source_updated_at"
    t.index ["deleted_at"], name: "index_sounds_on_deleted_at"
    t.index ["slug", "deleted_at"], name: "index_sounds_on_slug_and_deleted_at", unique: true
    t.index ["slug"], name: "index_sounds_on_slug"
  end

  create_table "stage_backdrops", force: :cascade do |t|
    t.integer "backdrop_id"
    t.integer "stage_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["backdrop_id"], name: "index_stage_backdrops_on_backdrop_id"
    t.index ["stage_id"], name: "index_stage_backdrops_on_stage_id"
  end

  create_table "stage_sounds", force: :cascade do |t|
    t.integer "stage_id"
    t.integer "sound_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sound_id"], name: "index_stage_sounds_on_sound_id"
    t.index ["stage_id"], name: "index_stage_sounds_on_stage_id"
  end

  create_table "stage_tags", force: :cascade do |t|
    t.integer "stage_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stage_id", "tag_id"], name: "index_stage_tags_on_stage_id_and_tag_id", unique: true
    t.index ["stage_id"], name: "index_stage_tags_on_stage_id"
    t.index ["tag_id"], name: "index_stage_tags_on_tag_id"
  end

  create_table "stages", force: :cascade do |t|
    t.string "name"
    t.bigint "owner_id", null: false
    t.datetime "deleted_at"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at", "slug"], name: "index_stages_on_deleted_at_and_slug", unique: true
    t.index ["deleted_at"], name: "index_stages_on_deleted_at"
    t.index ["slug"], name: "index_stages_on_slug"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "auth_token", null: false
    t.string "nickname", null: false
    t.boolean "is_active", default: false, null: false
    t.string "slug", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "email_confirmed"
    t.string "confirmation_token", default: "CONFIRMED", null: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.index ["deleted_at", "nickname"], name: "index_users_on_deleted_at_and_nickname", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["slug"], name: "index_users_on_slug"
  end

end
