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

class CDATANodeTest < Test::Unit::TestCase
  def setup
    @node = HTML::CDATA.new(nil, 0, 0, "<p>howdy</p>")
  end

  def test_to_s
    assert_equal "<![CDATA[<p>howdy</p>]]>", @node.to_s
  end

  def test_content
    assert_equal "<p>howdy</p>", @node.content
  end
end
