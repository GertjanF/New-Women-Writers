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

class TemplateTest < Test::Unit::TestCase
  def test_template_path_parsing
    with_options :base_path => nil, :name => 'abc', :locale => nil, :format => 'html', :extension => 'erb' do |t|
      t.assert_parses_template_path 'abc.en.html.erb',        :locale => 'en'
      t.assert_parses_template_path 'abc.en.plain.html.erb',  :locale => 'en', :format => 'plain.html'
      t.assert_parses_template_path 'abc.html.erb'
      t.assert_parses_template_path 'abc.plain.html.erb',     :format => 'plain.html'
      t.assert_parses_template_path 'abc.erb',                :format => nil
      t.assert_parses_template_path 'abc.html',               :extension => nil
      
      t.assert_parses_template_path '_abc.html.erb',          :name => '_abc'
      
      t.assert_parses_template_path 'test/abc.html.erb',      :base_path => 'test'
      t.assert_parses_template_path './test/abc.html.erb',    :base_path => './test'
      t.assert_parses_template_path '../test/abc.html.erb',   :base_path => '../test'
      
      t.assert_parses_template_path 'abc',                    :extension => nil, :format => nil, :name => nil
      t.assert_parses_template_path 'abc.xxx',                :extension => nil, :format => 'xxx', :name => 'abc'
      t.assert_parses_template_path 'abc.html.xxx',           :extension => nil, :format => 'xxx', :name => 'abc'
    end
  end

  private
  def assert_parses_template_path(path, parse_results)
    template = ActionView::Template.new(path, '')
    parse_results.each_pair do |k, v|
      assert_block(%Q{Expected template to parse #{k.inspect} from "#{path}" as #{v.inspect}, but got #{template.send(k).inspect}}) { v == template.send(k) }
    end
  end
end
