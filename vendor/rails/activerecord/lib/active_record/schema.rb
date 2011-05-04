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

module ActiveRecord
  # Allows programmers to programmatically define a schema in a portable
  # DSL. This means you can define tables, indexes, etc. without using SQL
  # directly, so your applications can more easily support multiple
  # databases.
  #
  # Usage:
  #
  #   ActiveRecord::Schema.define do
  #     create_table :authors do |t|
  #       t.string :name, :null => false
  #     end
  #
  #     add_index :authors, :name, :unique
  #
  #     create_table :posts do |t|
  #       t.integer :author_id, :null => false
  #       t.string :subject
  #       t.text :body
  #       t.boolean :private, :default => false
  #     end
  #
  #     add_index :posts, :author_id
  #   end
  #
  # ActiveRecord::Schema is only supported by database adapters that also
  # support migrations, the two features being very similar.
  class Schema < Migration
    private_class_method :new

    # Eval the given block. All methods available to the current connection
    # adapter are available within the block, so you can easily use the
    # database definition DSL to build up your schema (+create_table+,
    # +add_index+, etc.).
    #
    # The +info+ hash is optional, and if given is used to define metadata
    # about the current schema (currently, only the schema's version):
    #
    #   ActiveRecord::Schema.define(:version => 20380119000001) do
    #     ...
    #   end
    def self.define(info={}, &block)
      instance_eval(&block)

      unless info[:version].blank?
        initialize_schema_migrations_table
        assume_migrated_upto_version info[:version]
      end
    end
  end
end
