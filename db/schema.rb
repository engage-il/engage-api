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

ActiveRecord::Schema.define(version: 20170323052502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'
  enable_extension 'uuid-ossp'

  create_table 'bills', id: :uuid, default: -> { 'uuid_generate_v4()' }, force: :cascade do |t|
    t.integer  'external_id',      null: false
    t.string   'document_number',  null: false
    t.string   'title'
    t.string   'summary'
    t.string   'sponsor_name',     null: false
    t.string   'witness_slip_url'
    t.uuid     'hearing_id',       null: false
    t.datetime 'created_at',       null: false
    t.datetime 'updated_at',       null: false
    t.index ['external_id'], name: 'index_bills_on_external_id', unique: true, using: :btree
    t.index ['hearing_id'], name: 'index_bills_on_hearing_id', using: :btree
  end

  create_table 'chambers', id: :uuid, default: -> { 'uuid_generate_v4()' }, force: :cascade do |t|
    t.string   'name',       null: false
    t.integer  'kind',       null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'committees', id: :uuid, default: -> { 'uuid_generate_v4()' }, force: :cascade do |t|
    t.integer  'external_id', null: false
    t.string   'name',        null: false
    t.uuid     'chamber_id',  null: false
    t.datetime 'created_at',  null: false
    t.datetime 'updated_at',  null: false
    t.index ['chamber_id'], name: 'index_committees_on_chamber_id', using: :btree
    t.index ['external_id'], name: 'index_committees_on_external_id', unique: true, using: :btree
  end

  create_table 'hearings', id: :uuid, default: -> { 'uuid_generate_v4()' }, force: :cascade do |t|
    t.integer  'external_id',  null: false
    t.string   'url',          null: false
    t.string   'location',     null: false
    t.datetime 'date',         null: false
    t.boolean  'is_cancelled', null: false
    t.uuid     'committee_id', null: false
    t.datetime 'created_at',   null: false
    t.datetime 'updated_at',   null: false
    t.index ['committee_id'], name: 'index_hearings_on_committee_id', using: :btree
    t.index ['external_id'], name: 'index_hearings_on_external_id', unique: true, using: :btree
  end

end
