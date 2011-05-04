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

if ActiveRecord::Base.connection.supports_migrations?

  class ActiveRecordSchemaTest < ActiveRecord::TestCase
    self.use_transactional_fixtures = false

    def setup
      @connection = ActiveRecord::Base.connection
    end

    def teardown
      @connection.drop_table :fruits rescue nil
    end

    def test_schema_define
      ActiveRecord::Schema.define(:version => 7) do
        create_table :fruits do |t|
          t.column :color, :string
          t.column :fruit_size, :string  # NOTE: "size" is reserved in Oracle
          t.column :texture, :string
          t.column :flavor, :string
        end
      end

      assert_nothing_raised { @connection.select_all "SELECT * FROM fruits" }
      assert_nothing_raised { @connection.select_all "SELECT * FROM schema_migrations" }
      assert_equal 7, ActiveRecord::Migrator::current_version
    end
  end

end
