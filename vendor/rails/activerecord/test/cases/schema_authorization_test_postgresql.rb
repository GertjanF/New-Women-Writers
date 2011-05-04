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

require "cases/helper"

class SchemaThing < ActiveRecord::Base
end

class SchemaAuthorizationTest < ActiveRecord::TestCase
  self.use_transactional_fixtures = false

  TABLE_NAME = 'schema_things'
  COLUMNS = [
    'id serial primary key',
    'name character varying(50)'
  ]
  USERS = ['rails_pg_schema_user1', 'rails_pg_schema_user2']

  def setup
    @connection = ActiveRecord::Base.connection
    @connection.execute "SET search_path TO '$user',public"
    set_session_auth
    USERS.each do |u|
      @connection.execute "CREATE USER #{u}" rescue nil
      @connection.execute "CREATE SCHEMA AUTHORIZATION #{u}" rescue nil
      set_session_auth u
      @connection.execute "CREATE TABLE #{TABLE_NAME} (#{COLUMNS.join(',')})"
      @connection.execute "INSERT INTO #{TABLE_NAME} (name) VALUES ('#{u}')"
      set_session_auth
    end
  end

  def teardown
    set_session_auth
    @connection.execute "RESET search_path"
    USERS.each do |u|
      @connection.execute "DROP SCHEMA #{u} CASCADE"
      @connection.execute "DROP USER #{u}"
    end
  end

  def test_schema_invisible
    assert_raise(ActiveRecord::StatementInvalid) do
      set_session_auth
      @connection.execute "SELECT * FROM #{TABLE_NAME}"
    end
  end

  def test_schema_uniqueness
    assert_nothing_raised do
      set_session_auth
      USERS.each do |u|
        set_session_auth u
        assert_equal u, @connection.select_value("SELECT name FROM #{TABLE_NAME} WHERE id = 1")
        set_session_auth
      end
    end
  end

  def test_sequence_schema_caching
    assert_nothing_raised do
      USERS.each do |u|
        set_session_auth u
        st = SchemaThing.new :name => 'TEST1'
        st.save!
        st = SchemaThing.new :id => 5, :name => 'TEST2'
        st.save!
        set_session_auth
      end
    end
  end

  private
    def set_session_auth auth = nil
       @connection.execute "SET SESSION AUTHORIZATION #{auth || 'default'}"
    end

end
