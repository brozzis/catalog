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

ActiveRecord::Schema.define(:version => 20120108225537) do

  create_table "asso_cate", :force => true do |t|
    t.integer "cid"
    t.integer "pid"
  end

  create_table "campis", :force => true do |t|
    t.string   "nome"
    t.string   "s"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doppi", :id => false, :force => true do |t|
    t.string "t1_d"
    t.string "t2_d"
  end

  create_table "hashes", :primary_key => "hash", :force => true do |t|
    t.string "md5",  :limit => 32
    t.string "sha1", :limit => 42
  end

  create_table "imdb", :force => true do |t|
    t.integer "code",                     :null => false
    t.string  "title",     :limit => 120
    t.string  "year",      :limit => 10
    t.string  "plot",      :limit => 254
    t.string  "country",   :limit => 100
    t.string  "rating",    :limit => 32
    t.string  "tagline"
    t.string  "genres"
    t.string  "duration",  :limit => 50
    t.string  "directors"
    t.integer "pid"
    t.string  "crit",      :limit => 44
    t.boolean "fail"
  end

  add_index "imdb", ["pid"], :name => "pid", :unique => true

  create_table "tags", :force => true do |t|
    t.string "tag", :limit => 45, :null => false
  end

  create_table "tera", :force => true do |t|
    t.string    "d"
    t.string    "f"
    t.decimal   "size",                     :precision => 10, :scale => 0
    t.integer   "f_date"
    t.boolean   "flag_movie",                                              :default => false
    t.string    "hash",       :limit => 32
    t.timestamp "created_at",                                                                 :null => false
  end

  add_index "tera", ["hash"], :name => "IX_hash"

  create_table "vols", :force => true do |t|
    t.string "volname", :limit => 45
    t.string "located", :limit => 45
  end

end
