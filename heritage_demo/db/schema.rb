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

ActiveRecord::Schema.define(:version => 20110412094758) do

  create_table "_blog_posts_old_20110411", :force => true do |t|
    t.integer  "predecessor_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "_image_posts_old_20110411", :force => true do |t|
    t.integer  "predecessor_id"
    t.integer  "aspect"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blog_posts", :force => true do |t|
    t.text "body"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "image_posts", :force => true do |t|
    t.integer "aspect"
  end

  create_table "posts", :force => true do |t|
    t.integer  "heir_id"
    t.string   "heir_type"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

end
