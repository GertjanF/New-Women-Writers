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
require 'models/topic'
require 'models/task'

class DateTimeTest < ActiveRecord::TestCase
  def test_saves_both_date_and_time
    time_values = [1807, 2, 10, 15, 30, 45]
    now = DateTime.civil(*time_values)

    task = Task.new
    task.starting = now
    task.save!

    # check against Time.local_time, since some platforms will return a Time instead of a DateTime
    assert_equal Time.local_time(*time_values), Task.find(task.id).starting
  end

  def test_assign_empty_date_time
    task = Task.new
    task.starting = ''
    task.ending = nil
    assert_nil task.starting
    assert_nil task.ending
  end

  def test_assign_empty_date
    topic = Topic.new
    topic.last_read = ''
    assert_nil topic.last_read
  end

  def test_assign_empty_time
    topic = Topic.new
    topic.bonus_time = ''
    assert_nil topic.bonus_time
  end
end
