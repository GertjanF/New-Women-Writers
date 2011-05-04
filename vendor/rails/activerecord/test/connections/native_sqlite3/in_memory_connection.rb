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

def make_connection(clazz, db_definitions_file)
  clazz.establish_connection(:adapter => 'sqlite3', :database  => ':memory:')
  File.read(SCHEMA_ROOT + "/#{db_definitions_file}").split(';').each do |command|
    clazz.connection.execute(command) unless command.strip.empty?
  end
end

make_connection(ActiveRecord::Base, 'sqlite.sql')
make_connection(Course, 'sqlite2.sql')
load(SCHEMA_ROOT + "/schema.rb")
