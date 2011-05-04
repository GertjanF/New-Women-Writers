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
require 'models/default'

class DefaultTest < ActiveRecord::TestCase
  def test_default_timestamp
    default = Default.new
    assert_instance_of(Time, default.default_timestamp)
    assert_equal(:datetime, default.column_for_attribute(:default_timestamp).type)

    # Variance should be small; increase if required -- e.g., if test db is on
    # remote host and clocks aren't synchronized.
    t1 = Time.new
    accepted_variance = 1.0
    assert_in_delta(t1.to_f, default.default_timestamp.to_f, accepted_variance)
  end
end
