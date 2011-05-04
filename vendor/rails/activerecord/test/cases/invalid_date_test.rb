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
require 'models/topic'

class InvalidDateTest < Test::Unit::TestCase
  def test_assign_valid_dates
    valid_dates = [[2007, 11, 30], [1993, 2, 28], [2008, 2, 29]]

    invalid_dates = [[2007, 11, 31], [1993, 2, 29], [2007, 2, 29]]

    topic = Topic.new

    valid_dates.each do |date_src|
      topic = Topic.new("last_read(1i)" => date_src[0].to_s, "last_read(2i)" => date_src[1].to_s, "last_read(3i)" => date_src[2].to_s)
      assert_equal(topic.last_read, Date.new(*date_src))
    end

    invalid_dates.each do |date_src|
      assert_nothing_raised do
        topic = Topic.new({"last_read(1i)" => date_src[0].to_s, "last_read(2i)" => date_src[1].to_s, "last_read(3i)" => date_src[2].to_s})
        assert_equal(topic.last_read, Time.local(*date_src).to_date, "The date should be modified according to the behaviour of the Time object")
      end
    end
  end
end
