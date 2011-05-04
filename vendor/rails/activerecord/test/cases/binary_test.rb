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

# Without using prepared statements, it makes no sense to test
# BLOB data with DB2 or Firebird, because the length of a statement
# is limited to 32KB.
unless current_adapter?(:SybaseAdapter, :DB2Adapter, :FirebirdAdapter)
  require 'models/binary'

  class BinaryTest < ActiveRecord::TestCase
    FIXTURES = %w(flowers.jpg example.log)

    def test_load_save
      Binary.delete_all

      FIXTURES.each do |filename|
        data = File.read(ASSETS_ROOT + "/#{filename}")
        data.force_encoding('ASCII-8BIT') if data.respond_to?(:force_encoding)
        data.freeze

        bin = Binary.new(:data => data)
        assert_equal data, bin.data, 'Newly assigned data differs from original'

        bin.save!
        assert_equal data, bin.data, 'Data differs from original after save'

        assert_equal data, bin.reload.data, 'Reloaded data differs from original'
      end
    end
  end
end
