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

require 'test/unit'
require "cases/helper"
require 'active_support/core_ext/class/inheritable_attributes'

class A
  include ClassInheritableAttributes
end

class B < A
  write_inheritable_array "first", [ :one, :two ]
end

class C < A
  write_inheritable_array "first", [ :three ]
end

class D < B
  write_inheritable_array "first", [ :four ]
end


class ClassInheritableAttributesTest < ActiveRecord::TestCase
  def test_first_level
    assert_equal [ :one, :two ], B.read_inheritable_attribute("first")
    assert_equal [ :three ], C.read_inheritable_attribute("first")
  end

  def test_second_level
    assert_equal [ :one, :two, :four ], D.read_inheritable_attribute("first")
    assert_equal [ :one, :two ], B.read_inheritable_attribute("first")
  end
end
