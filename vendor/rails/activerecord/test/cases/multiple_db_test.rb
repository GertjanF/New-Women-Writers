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
require 'models/entrant'

# So we can test whether Course.connection survives a reload.
require_dependency 'models/course'

class MultipleDbTest < ActiveRecord::TestCase
  self.use_transactional_fixtures = false

  def setup
    @courses  = create_fixtures("courses") { Course.retrieve_connection }
    @entrants = create_fixtures("entrants")
  end

  def test_connected
    assert_not_nil Entrant.connection
    assert_not_nil Course.connection
  end

  def test_proper_connection
    assert_not_equal(Entrant.connection, Course.connection)
    assert_equal(Entrant.connection, Entrant.retrieve_connection)
    assert_equal(Course.connection, Course.retrieve_connection)
    assert_equal(ActiveRecord::Base.connection, Entrant.connection)
  end

  def test_find
    c1 = Course.find(1)
    assert_equal "Ruby Development", c1.name
    c2 = Course.find(2)
    assert_equal "Java Development", c2.name
    e1 = Entrant.find(1)
    assert_equal "Ruby Developer", e1.name
    e2 = Entrant.find(2)
    assert_equal "Ruby Guru", e2.name
    e3 = Entrant.find(3)
    assert_equal "Java Lover", e3.name
  end

  def test_associations
    c1 = Course.find(1)
    assert_equal 2, c1.entrants.count
    e1 = Entrant.find(1)
    assert_equal e1.course.id, c1.id
    c2 = Course.find(2)
    assert_equal 1, c2.entrants.count
    e3 = Entrant.find(3)
    assert_equal e3.course.id, c2.id
  end

  def test_course_connection_should_survive_dependency_reload
    assert Course.connection

    ActiveSupport::Dependencies.clear
    Object.send(:remove_const, :Course)
    require_dependency 'models/course'

    assert Course.connection
  end

  def test_transactions_across_databases
    c1 = Course.find(1)
    e1 = Entrant.find(1)

    begin
      Course.transaction do
        Entrant.transaction do
          c1.name = "Typo"
          e1.name = "Typo"
          c1.save
          e1.save
          raise "No I messed up."
        end
      end
    rescue
      # Yup caught it
    end

    assert_equal "Typo", c1.name
    assert_equal "Typo", e1.name

    assert_equal "Ruby Development", Course.find(1).name
    assert_equal "Ruby Developer", Entrant.find(1).name
  end
end
