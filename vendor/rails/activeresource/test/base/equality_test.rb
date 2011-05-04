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

require 'abstract_unit'
require "fixtures/person"
require "fixtures/street_address"

class BaseEqualityTest < Test::Unit::TestCase
  def setup
    @new = Person.new
    @one = Person.new(:id => 1)
    @two = Person.new(:id => 2)
    @street = StreetAddress.new(:id => 2)
  end

  def test_should_equal_self
    assert @new == @new, '@new == @new'
    assert @one == @one, '@one == @one'
  end

  def test_shouldnt_equal_new_resource
    assert @new != @one, '@new != @one'
    assert @one != @new, '@one != @new'
  end

  def test_shouldnt_equal_different_class
    assert @two != @street, 'person != street_address with same id'
    assert @street != @two, 'street_address != person with same id'
  end

  def test_eql_should_alias_equals_operator
    assert_equal @new == @new, @new.eql?(@new)
    assert_equal @new == @one, @new.eql?(@one)

    assert_equal @one == @one, @one.eql?(@one)
    assert_equal @one == @new, @one.eql?(@new)

    assert_equal @one == @street, @one.eql?(@street)
  end

  def test_hash_should_be_id_hash
    [@new, @one, @two, @street].each do |resource|
      assert_equal resource.id.hash, resource.hash
    end
  end

	def test_with_prefix_options
    assert_equal @one == @one, @one.eql?(@one)
    assert_equal @one == @one.dup, @one.eql?(@one.dup)
    new_one = @one.dup
    new_one.prefix_options = {:foo => 'bar'}
    assert_not_equal @one, new_one
	end

end
