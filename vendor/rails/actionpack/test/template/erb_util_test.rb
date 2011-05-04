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

class ErbUtilTest < Test::Unit::TestCase
  include ERB::Util

  ERB::Util::HTML_ESCAPE.each do |given, expected|
    define_method "test_html_escape_#{expected.gsub /\W/, ''}" do
      assert_equal expected, html_escape(given)
    end

    unless given == '"'
      define_method "test_json_escape_#{expected.gsub /\W/, ''}" do
        assert_equal ERB::Util::JSON_ESCAPE[given], json_escape(given)
      end
    end
  end
  
  def test_rest_in_ascii
    (0..127).to_a.map(&:chr).each do |chr|
      next if %w(& " < >).include?(chr)
      assert_equal chr, html_escape(chr)
    end
  end
end
