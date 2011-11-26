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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111126094926) do

  create_table "articles", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "element_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "elements", :force => true do |t|
    t.integer  "element_type_id"
    t.integer  "growth_id",       :default => 1
    t.string   "url_swf"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", :force => true do |t|
    t.integer  "user_id"
    t.integer  "zero_x"
    t.integer  "zero_y"
    t.integer  "size_x"
    t.integer  "size_y"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "growths", :force => true do |t|
    t.integer  "stage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "magazines", :force => true do |t|
    t.string   "title"
    t.string   "author"
    t.text     "article"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plant_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plants", :force => true do |t|
    t.integer  "field_id"
    t.integer  "x"
    t.integer  "y"
    t.integer  "element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
