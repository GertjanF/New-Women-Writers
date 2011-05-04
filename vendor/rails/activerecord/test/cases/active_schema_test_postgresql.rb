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

require 'cases/helper'

class PostgresqlActiveSchemaTest < Test::Unit::TestCase
  def setup
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
      alias_method :real_execute, :execute
      def execute(sql, name = nil) sql end
    end
  end

  def teardown
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:alias_method, :execute, :real_execute)
  end

  def test_create_database_with_encoding
    assert_equal %(CREATE DATABASE "matt" ENCODING = 'utf8'), create_database(:matt)
    assert_equal %(CREATE DATABASE "aimonetti" ENCODING = 'latin1'), create_database(:aimonetti, :encoding => :latin1)
  end

  private
    def method_missing(method_symbol, *arguments)
      ActiveRecord::Base.connection.send(method_symbol, *arguments)
    end
end
