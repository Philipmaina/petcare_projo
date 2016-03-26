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

ActiveRecord::Schema.define(version: 20160325144944) do

  create_table "junctionofpetsitterandpettypes", force: :cascade do |t|
    t.integer  "pettype_id"
    t.integer  "petsitter_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "junctionofpetsitterandpettypes", ["petsitter_id"], name: "index_junctionofpetsitterandpettypes_on_petsitter_id"
  add_index "junctionofpetsitterandpettypes", ["pettype_id"], name: "index_junctionofpetsitterandpettypes_on_pettype_id"

  create_table "junctionofservicesandpetsitters", force: :cascade do |t|
    t.integer  "petsitter_id"
    t.integer  "sittingservice_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "junctionofservicesandpetsitters", ["petsitter_id"], name: "index_junctionofservicesandpetsitters_on_petsitter_id"
  add_index "junctionofservicesandpetsitters", ["sittingservice_id"], name: "index_junctionofservicesandpetsitters_on_sittingservice_id"

  create_table "petowners", force: :cascade do |t|
    t.string   "first_name"
    t.string   "surname"
    t.string   "other_names"
    t.date     "date_of_birth"
    t.string   "personal_email"
    t.string   "contact_line_one"
    t.string   "contact_line_two"
    t.string   "profile_pic_file_name"
    t.integer  "residential_area_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "password_digest"
  end

  add_index "petowners", ["residential_area_id"], name: "index_petowners_on_residential_area_id"

  create_table "pets", force: :cascade do |t|
    t.integer  "pettype_id"
    t.integer  "petowner_id"
    t.string   "pet_name"
    t.integer  "years_pet_lived"
    t.integer  "months_pet_lived"
    t.string   "gender"
    t.string   "breed"
    t.string   "size_of_pet"
    t.string   "default_pet_pic_file_name"
    t.string   "alternative_pic_file_name"
    t.text     "care_handle_instructions"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "pets", ["petowner_id"], name: "index_pets_on_petowner_id"
  add_index "pets", ["pettype_id"], name: "index_pets_on_pettype_id"

  create_table "petsitters", force: :cascade do |t|
    t.string   "first_name"
    t.string   "surname"
    t.string   "other_names"
    t.date     "date_of_birth"
    t.integer  "residential_area_id"
    t.string   "personal_email"
    t.string   "contact_line_one"
    t.string   "contact_line_two"
    t.integer  "no_of_yrs_caring"
    t.integer  "no_of_pets_owned"
    t.string   "type_of_home"
    t.boolean  "presence_of_open_area_outside_home"
    t.string   "work_situation"
    t.integer  "day_charges",                        default: 0
    t.integer  "night_charges",                      default: 0
    t.string   "default_pic_file_name"
    t.string   "listing_name"
    t.text     "profile_description"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "password_digest"
  end

  add_index "petsitters", ["residential_area_id"], name: "index_petsitters_on_residential_area_id"

  create_table "pettypes", force: :cascade do |t|
    t.string   "type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "residential_areas", force: :cascade do |t|
    t.string   "name_of_location"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "sittingservices", force: :cascade do |t|
    t.string   "service_name"
    t.text     "service_description"
    t.string   "place_offered"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "unavailabledates", force: :cascade do |t|
    t.integer  "petsitter_id"
    t.date     "unavailable_dates_on"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "unavailabledates", ["petsitter_id"], name: "index_unavailabledates_on_petsitter_id"

end
