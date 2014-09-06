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

ActiveRecord::Schema.define(version: 20140623162224) do

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cities", ["country_id"], name: "index_cities_on_country_id"
  add_index "cities", ["state_id"], name: "index_cities_on_state_id"

  create_table "companies", force: true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.integer  "state_id"
    t.integer  "city_id"
    t.string   "address"
    t.string   "address_complement"
    t.string   "number"
    t.integer  "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "companies", ["city_id"], name: "index_companies_on_city_id"
  add_index "companies", ["country_id"], name: "index_companies_on_country_id"
  add_index "companies", ["state_id"], name: "index_companies_on_state_id"

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_cards", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "installments", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "installments_credit_cads", force: true do |t|
    t.integer  "installment_id"
    t.integer  "credit_card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "installments_credit_cads", ["credit_card_id"], name: "index_installments_credit_cads_on_credit_card_id"
  add_index "installments_credit_cads", ["installment_id"], name: "index_installments_credit_cads_on_installment_id"

  create_table "jobs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "dob"
    t.integer  "country_id"
    t.integer  "state_id"
    t.integer  "city_id"
    t.string   "address"
    t.string   "address_complement"
    t.string   "number"
    t.integer  "zipcode"
    t.boolean  "employed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "birth_date"
  end

  add_index "people", ["city_id"], name: "index_people_on_city_id"
  add_index "people", ["country_id"], name: "index_people_on_country_id"
  add_index "people", ["state_id"], name: "index_people_on_state_id"

  create_table "person_histories", force: true do |t|
    t.integer  "person_id"
    t.text     "history"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "person_histories", ["person_id"], name: "index_person_histories_on_person_id"

  create_table "professional_experiences", force: true do |t|
    t.integer  "people_id"
    t.integer  "company_id"
    t.integer  "job_id"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "finished_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "professional_experiences", ["company_id"], name: "index_professional_experiences_on_company_id"
  add_index "professional_experiences", ["job_id"], name: "index_professional_experiences_on_job_id"
  add_index "professional_experiences", ["people_id"], name: "index_professional_experiences_on_people_id"

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["country_id"], name: "index_states_on_country_id"

end
