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

print "Using native SQLite3\n"
require_dependency 'models/course'
require 'logger'
ActiveRecord::Base.logger = Logger.new("debug.log")

class SqliteError < StandardError
end

BASE_DIR = FIXTURES_ROOT
sqlite_test_db  = "#{BASE_DIR}/fixture_database.sqlite3"
sqlite_test_db2 = "#{BASE_DIR}/fixture_database_2.sqlite3"

def make_connection(clazz, db_file)
  ActiveRecord::Base.configurations = { clazz.name => { :adapter => 'sqlite3', :database => db_file, :timeout => 5000 } }
  unless File.exist?(db_file)
    puts "SQLite3 database not found at #{db_file}. Rebuilding it."
    sqlite_command = %Q{sqlite3 "#{db_file}" "create table a (a integer); drop table a;"}
    puts "Executing '#{sqlite_command}'"
    raise SqliteError.new("Seems that there is no sqlite3 executable available") unless system(sqlite_command)
  end
  clazz.establish_connection(clazz.name)
end

make_connection(ActiveRecord::Base, sqlite_test_db)
make_connection(Course, sqlite_test_db2)
