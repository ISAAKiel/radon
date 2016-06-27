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

ActiveRecord::Schema.define(version: 20160627120404) do

  create_table "announcements", force: :cascade do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.string   "abreviation"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "country_subdivisions", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.integer  "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "country_subdivisions", ["country_id"], name: "index_country_subdivisions_on_country_id"

  create_table "cultures", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dating_methods", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feature_types", force: :cascade do |t|
    t.string   "name"
    t.text     "comment"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "labs", force: :cascade do |t|
    t.string   "name"
    t.integer  "dating_method_id"
    t.string   "lab_code"
    t.string   "country"
    t.boolean  "active"
    t.integer  "position"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "labs", ["dating_method_id"], name: "index_labs_on_dating_method_id"

  create_table "literatures", force: :cascade do |t|
    t.string   "short_citation"
    t.string   "year"
    t.string   "author"
    t.text     "long_citation"
    t.string   "url"
    t.boolean  "approved"
    t.text     "bibtex"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "pages", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phases", force: :cascade do |t|
    t.string   "name"
    t.integer  "culture_id"
    t.boolean  "approved"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "phases", ["culture_id"], name: "index_phases_on_culture_id"

  create_table "prmats", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rights", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samples", force: :cascade do |t|
    t.integer  "lab_id"
    t.string   "lab_nr"
    t.integer  "bp"
    t.integer  "std"
    t.float    "delta_13_c"
    t.float    "delta_13_c_std"
    t.integer  "prmat_id"
    t.text     "prmat_comment"
    t.text     "comment"
    t.string   "feature"
    t.integer  "feature_type_id"
    t.integer  "phase_id"
    t.integer  "site_id"
    t.boolean  "approved"
    t.integer  "right_id"
    t.integer  "dating_method_id"
    t.string   "contact_e_mail"
    t.string   "creator_ip"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "samples", ["dating_method_id"], name: "index_samples_on_dating_method_id"
  add_index "samples", ["feature_type_id"], name: "index_samples_on_feature_type_id"
  add_index "samples", ["lab_id"], name: "index_samples_on_lab_id"
  add_index "samples", ["phase_id"], name: "index_samples_on_phase_id"
  add_index "samples", ["prmat_id"], name: "index_samples_on_prmat_id"
  add_index "samples", ["right_id"], name: "index_samples_on_right_id"
  add_index "samples", ["site_id"], name: "index_samples_on_site_id"

  create_table "sites", force: :cascade do |t|
    t.string   "name"
    t.string   "parish"
    t.string   "district"
    t.integer  "country_subdivision_id"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "sites", ["country_subdivision_id"], name: "index_sites_on_country_subdivision_id"

end
