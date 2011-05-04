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

print "Using Postgrsql via JRuby, activerecord-jdbc-adapter and activerecord-postgresql-adapter\n"
require_dependency 'models/course'
require 'logger'

ActiveRecord::Base.logger = Logger.new("debug.log")

# createuser rails --createdb --no-superuser --no-createrole
# createdb -O rails activerecord_unittest
# createdb -O rails activerecord_unittest2

ActiveRecord::Base.configurations = {
  'arunit' => {
    :adapter  => 'jdbcpostgresql',
    :username => ENV['USER'] || 'rails',
    :database => 'activerecord_unittest'
  },
  'arunit2' => {
    :adapter  => 'jdbcpostgresql',
    :username => ENV['USER'] || 'rails',
    :database => 'activerecord_unittest2'
  }
}

ActiveRecord::Base.establish_connection 'arunit'
Course.establish_connection 'arunit2'

