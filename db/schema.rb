#
# Copyright 2009 Huygens Instituut for the History of the Netherlands, Den Haag, The Netherlands.
#
# This file is part of New Women Writers.
#
# New Women Writers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# New Women Writers is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with New Women Writers.  If not, see <http://www.gnu.org/licenses/>.
#

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100723135251) do

  create_table "author_urls", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "author_urls", ["author_id"], :name => "index_author_id"

  create_table "authors", :force => true do |t|
    t.integer  "oldid"
    t.string   "name"
    t.string   "gender"
    t.integer  "year_born"
    t.integer  "year_death"
    t.text     "bibliography"
    t.text     "financial_situation"
    t.text     "personal_situation"
    t.string   "spouse"
    t.integer  "children"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reader",              :default => true, :null => false
  end

  add_index "authors", ["id"], :name => "index_author_on_id", :unique => true
  add_index "authors", ["name"], :name => "index_author_on_name"

  create_table "authors_countries", :id => false, :force => true do |t|
    t.integer  "author_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors_countries", ["author_id"], :name => "index_on_author"
  add_index "authors_countries", ["country_id"], :name => "index_on_country"

  create_table "authors_languages", :id => false, :force => true do |t|
    t.integer  "author_id"
    t.integer  "language_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors_languages", ["author_id"], :name => "index_language_on_author"
  add_index "authors_languages", ["language_id"], :name => "index_language_on_language"

  create_table "changes", :force => true do |t|
    t.string   "object_name"
    t.integer  "object_id"
    t.string   "changetype"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "approved",    :default => 0
    t.date     "old_update"
    t.string   "object_type"
  end

  add_index "changes", ["object_id"], :name => "changes_object_id_index"
  add_index "changes", ["object_name"], :name => "changes_object_name_index"
  add_index "changes", ["user_id"], :name => "changes_user_id_index"

  create_table "countries", :force => true do |t|
    t.integer  "oldid"
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language"
  end

  add_index "countries", ["id"], :name => "index_on_country_id"
  add_index "countries", ["name"], :name => "index_on_name"

  create_table "genres", :force => true do |t|
    t.integer  "oldid"
    t.string   "genre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres", ["genre"], :name => "index_genres_on_genre"
  add_index "genres", ["id"], :name => "index_genres_on_id"

  create_table "genres_works", :id => false, :force => true do |t|
    t.integer  "genre_id"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "genres_works", ["genre_id"], :name => "genres_on_genre_id_index"
  add_index "genres_works", ["work_id"], :name => "genres_on_work_id_index"

  create_table "helps", :force => true do |t|
    t.string   "object_controller"
    t.string   "object_action"
    t.text     "help_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "language"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "oldid"
  end

  add_index "languages", ["id"], :name => "language_on_id_index"
  add_index "languages", ["language"], :name => "language_on_language_index"

  create_table "libraries", :force => true do |t|
    t.integer  "oldid"
    t.string   "name"
    t.string   "short_name"
    t.string   "address"
    t.string   "postcode"
    t.string   "city"
    t.string   "url"
    t.string   "telephone"
    t.string   "email"
    t.text     "notes"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "libraries", ["id"], :name => "index_libraries_on_id"
  add_index "libraries", ["oldid"], :name => "index_libraries_on_oldid"

  create_table "media", :force => true do |t|
    t.integer  "oldid"
    t.string   "medium"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["id"], :name => "index_media_on_id"
  add_index "media", ["medium"], :name => "index_media_on_medium"

  create_table "prints", :force => true do |t|
    t.integer  "year"
    t.string   "publisher"
    t.string   "location"
    t.string   "edition"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prints", ["id"], :name => "index_prints_on_id"
  add_index "prints", ["work_id"], :name => "index_prints_on_work_id"
  add_index "prints", ["year"], :name => "index_prints_on_year"

  create_table "pseudonyms", :force => true do |t|
    t.string   "pseudonym"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pseudonyms", ["author_id"], :name => "index_pseudonyms_on_author_id"
  add_index "pseudonyms", ["id"], :name => "index_pseudonyms_on_id"
  add_index "pseudonyms", ["pseudonym"], :name => "index_pseudonyms_on_pseudonym"

  create_table "reception_libs", :force => true do |t|
    t.integer  "copies"
    t.integer  "reception_id"
    t.integer  "library_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reception_libs", ["id"], :name => "index_receplibs_on_id"
  add_index "reception_libs", ["library_id"], :name => "index_receplibs_on_library_id"
  add_index "reception_libs", ["reception_id"], :name => "index_receplibs_on_reception_id"

  create_table "reception_urls", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "reception_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reception_urls", ["id"], :name => "index_recepurl_on_id"
  add_index "reception_urls", ["reception_id"], :name => "index_recepurl_on_reception_id"

  create_table "receptions", :force => true do |t|
    t.integer  "oldid"
    t.string   "title"
    t.integer  "year"
    t.text     "references"
    t.text     "excerpt"
    t.integer  "work_id"
    t.integer  "author_id"
    t.integer  "source_id"
    t.integer  "medium_id"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
  end

  add_index "receptions", ["author_id"], :name => "index_receptions_on_author_id"
  add_index "receptions", ["id"], :name => "index_receptions_on_id", :unique => true
  add_index "receptions", ["title"], :name => "index_reception_on_title"
  add_index "receptions", ["work_id"], :name => "index_receptions_on_work_id"

  create_table "relation_types", :force => true do |t|
    t.integer  "oldid"
    t.string   "parent_male"
    t.string   "parent_female"
    t.string   "child_male"
    t.string   "child_female"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relation_types", ["id"], :name => "index_reltypes_on_id"

  create_table "relations", :force => true do |t|
    t.integer  "author_id"
    t.integer  "relation_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relative_id"
  end

  add_index "relations", ["author_id"], :name => "index_relations_on_author_id"
  add_index "relations", ["relative_id"], :name => "index_relations_on_relative_id"

  create_table "sources", :force => true do |t|
    t.integer  "oldid"
    t.string   "short_name"
    t.string   "full_name"
    t.string   "source_type"
    t.text     "progress"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sources", ["full_name"], :name => "index_sources_on_full_name"
  add_index "sources", ["id"], :name => "index_sources_on_id"
  add_index "sources", ["source_type"], :name => "index_sources_on_source_type"

  create_table "topois", :force => true do |t|
    t.integer  "oldid"
    t.string   "topos"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topois", ["id"], :name => "index_topoi_on_id"
  add_index "topois", ["topos"], :name => "index_topoi_on_topos"

  create_table "topois_works", :id => false, :force => true do |t|
    t.integer  "topoi_id"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "topois_works", ["topoi_id"], :name => "index_topowork_on_topoi_id"
  add_index "topois_works", ["work_id"], :name => "index_topowork_on_work_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "encrypted_password"
    t.integer  "level",                            :default => 3
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt",               :limit => 40
    t.integer  "oldid"
    t.string   "email"
  end

  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "work_libs", :force => true do |t|
    t.integer  "copies"
    t.integer  "work_id"
    t.integer  "library_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_libs", ["id"], :name => "index_worklib_on_id"
  add_index "work_libs", ["library_id"], :name => "index_worklibs_on_library_id"
  add_index "work_libs", ["work_id"], :name => "index_worklib_on_work_id"

  create_table "work_urls", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "work_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "work_urls", ["id"], :name => "index_workurl_on_id"
  add_index "work_urls", ["work_id"], :name => "index_workurl_on_work_id"

  create_table "works", :force => true do |t|
    t.integer  "oldid"
    t.string   "title"
    t.integer  "publish_year"
    t.text     "notes"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "language_id"
    t.integer  "country_id"
  end

  add_index "works", ["author_id"], :name => "index_works_on_author_id"
  add_index "works", ["id"], :name => "index_works_on_id", :unique => true
  add_index "works", ["title"], :name => "index_works_on_title"

end
