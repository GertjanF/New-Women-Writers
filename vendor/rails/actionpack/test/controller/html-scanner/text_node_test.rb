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

class TextNodeTest < Test::Unit::TestCase
  def setup
    @node = HTML::Text.new(nil, 0, 0, "hello, howdy, aloha, annyeong")
  end
  
  def test_to_s
    assert_equal "hello, howdy, aloha, annyeong", @node.to_s
  end
  
  def test_find_string
    assert_equal @node, @node.find("hello, howdy, aloha, annyeong")
    assert_equal false, @node.find("bogus")
  end
  
  def test_find_regexp
    assert_equal @node, @node.find(/an+y/)
    assert_nil @node.find(/b/)
  end
  
  def test_find_hash
    assert_equal @node, @node.find(:content => /howdy/)
    assert_nil @node.find(:content => /^howdy$/)
    assert_equal false, @node.find(:content => "howdy")
  end
  
  def test_find_other
    assert_nil @node.find(:hello)
  end

  def test_match_string
    assert @node.match("hello, howdy, aloha, annyeong")
    assert_equal false, @node.match("bogus")
  end

  def test_match_regexp
    assert_not_nil @node, @node.match(/an+y/)
    assert_nil @node.match(/b/)
  end

  def test_match_hash
    assert_not_nil @node, @node.match(:content => "howdy")
    assert_nil @node.match(:content => /^howdy$/)
  end

  def test_match_other
    assert_nil @node.match(:hello)
  end
end