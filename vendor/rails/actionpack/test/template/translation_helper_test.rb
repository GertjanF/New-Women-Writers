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

class TranslationHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TranslationHelper
  
  attr_reader :request
  def setup
  end
  
  def test_delegates_to_i18n_setting_the_raise_option
    I18n.expects(:translate).with(:foo, :locale => 'en', :raise => true)
    translate :foo, :locale => 'en'
  end
  
  def test_returns_missing_translation_message_wrapped_into_span
    expected = '<span class="translation_missing">en, foo</span>'
    assert_equal expected, translate(:foo)
  end

  def test_delegates_localize_to_i18n
    @time = Time.utc(2008, 7, 8, 12, 18, 38)
    I18n.expects(:localize).with(@time)
    localize @time
  end
  
  def test_scoping_by_partial
    expects(:template).returns(stub(:path_without_format_and_extension => "people/index"))
    I18n.expects(:translate).with("people.index.foo", :locale => 'en', :raise => true)
    translate ".foo", :locale => 'en'
  end
end
