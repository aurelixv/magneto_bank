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

ActiveRecord::Schema.define(version: 20_181_015_004_041) do
  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.integer 'record_id', null: false
    t.integer 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'cards', force: :cascade do |t|
    t.boolean 'card_type'
    t.string 'card_number'
    t.integer 'verification_number'
    t.date 'aquisition_date'
    t.date 'due_date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'client_id'
  end

  create_table 'clients', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'address'
    t.integer 'zip_code'
    t.string 'password'
    t.bigint 'ssid'
    t.date 'birth_date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'transactions', force: :cascade do |t|
    t.string 'transaction_type'
    t.float 'value'
    t.date 'transaction_date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'card_id'
  end
end
