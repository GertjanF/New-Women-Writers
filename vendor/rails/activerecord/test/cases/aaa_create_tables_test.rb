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

# The filename begins with "aaa" to ensure this is the first test.
require "cases/helper"

class AAACreateTablesTest < ActiveRecord::TestCase
  self.use_transactional_fixtures = false

  def test_load_schema
    eval(File.read(SCHEMA_ROOT + "/schema.rb"))
    if File.exists?(adapter_specific_schema_file)
      eval(File.read(adapter_specific_schema_file))
    end
    assert true
  end

  def test_drop_and_create_courses_table
    eval(File.read(SCHEMA_ROOT + "/schema2.rb"))
    assert true
  end

  private
  def adapter_specific_schema_file
    SCHEMA_ROOT + '/' + ActiveRecord::Base.connection.adapter_name.downcase + '_specific_schema.rb'
  end
end
