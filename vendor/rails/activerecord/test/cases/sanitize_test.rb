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
require 'models/binary'

class SanitizeTest < ActiveRecord::TestCase
  def setup
  end

  def test_sanitize_sql_array_handles_string_interpolation
    quoted_bambi = ActiveRecord::Base.connection.quote_string("Bambi")
    assert_equal "name=#{quoted_bambi}", Binary.send(:sanitize_sql_array, ["name=%s", "Bambi"])
    assert_equal "name=#{quoted_bambi}", Binary.send(:sanitize_sql_array, ["name=%s", "Bambi".mb_chars])
    quoted_bambi_and_thumper = ActiveRecord::Base.connection.quote_string("Bambi\nand\nThumper")
    assert_equal "name=#{quoted_bambi_and_thumper}",Binary.send(:sanitize_sql_array, ["name=%s", "Bambi\nand\nThumper"])
    assert_equal "name=#{quoted_bambi_and_thumper}",Binary.send(:sanitize_sql_array, ["name=%s", "Bambi\nand\nThumper".mb_chars])
  end

  def test_sanitize_sql_array_handles_bind_variables
    quoted_bambi = ActiveRecord::Base.connection.quote("Bambi")
    assert_equal "name=#{quoted_bambi}", Binary.send(:sanitize_sql_array, ["name=?", "Bambi"])
    assert_equal "name=#{quoted_bambi}", Binary.send(:sanitize_sql_array, ["name=?", "Bambi".mb_chars])
    quoted_bambi_and_thumper = ActiveRecord::Base.connection.quote("Bambi\nand\nThumper")
    assert_equal "name=#{quoted_bambi_and_thumper}", Binary.send(:sanitize_sql_array, ["name=?", "Bambi\nand\nThumper"])
    assert_equal "name=#{quoted_bambi_and_thumper}", Binary.send(:sanitize_sql_array, ["name=?", "Bambi\nand\nThumper".mb_chars])
  end
end
