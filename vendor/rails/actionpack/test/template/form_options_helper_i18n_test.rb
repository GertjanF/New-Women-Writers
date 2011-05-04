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

class FormOptionsHelperI18nTests < ActionView::TestCase
  tests ActionView::Helpers::FormOptionsHelper

  def setup
    @prompt_message = 'Select!'
    I18n.backend.send(:init_translations)
    I18n.backend.store_translations :en, :support => { :select => { :prompt => @prompt_message } }
  end

  def teardown
    I18n.backend = I18n::Backend::Simple.new
  end

  def test_select_with_prompt_true_translates_prompt_message
    I18n.expects(:translate).with('support.select.prompt', { :default => 'Please select' })
    select('post', 'category', [], :prompt => true)
  end

  def test_select_with_translated_prompt
    assert_dom_equal(
      %Q(<select id="post_category" name="post[category]"><option value="">#{@prompt_message}</option>\n</select>),
      select('post', 'category', [], :prompt => true)
    )
  end
end