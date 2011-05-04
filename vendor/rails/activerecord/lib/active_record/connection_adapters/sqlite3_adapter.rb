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

require 'active_record/connection_adapters/sqlite_adapter'

module ActiveRecord
  class Base
    # sqlite3 adapter reuses sqlite_connection.
    def self.sqlite3_connection(config) # :nodoc:
      parse_sqlite_config!(config)

      unless self.class.const_defined?(:SQLite3)
        require_library_or_gem(config[:adapter])
      end

      db = SQLite3::Database.new(
        config[:database],
        :results_as_hash => true,
        :type_translation => false
      )

      db.busy_timeout(config[:timeout]) unless config[:timeout].nil?

      ConnectionAdapters::SQLite3Adapter.new(db, logger, config)
    end
  end

  module ConnectionAdapters #:nodoc:
    class SQLite3Adapter < SQLiteAdapter # :nodoc:
      def table_structure(table_name)
        returning structure = @connection.table_info(quote_table_name(table_name)) do
          raise(ActiveRecord::StatementInvalid, "Could not find table '#{table_name}'") if structure.empty?
        end
      end
    end
  end
end
