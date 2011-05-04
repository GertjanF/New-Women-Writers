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
require 'models/reply'

class ActiveRecordI18nTests < Test::Unit::TestCase

  def setup
    I18n.backend = I18n::Backend::Simple.new
  end
  
  def test_translated_model_attributes
    I18n.backend.store_translations 'en', :activerecord => {:attributes => {:topic => {:title => 'topic title attribute'} } }
    assert_equal 'topic title attribute', Topic.human_attribute_name('title')
  end
  
  def test_translated_model_attributes_with_symbols
    I18n.backend.store_translations 'en', :activerecord => {:attributes => {:topic => {:title => 'topic title attribute'} } }
    assert_equal 'topic title attribute', Topic.human_attribute_name(:title)
  end

  def test_translated_model_attributes_with_sti
    I18n.backend.store_translations 'en', :activerecord => {:attributes => {:reply => {:title => 'reply title attribute'} } }
    assert_equal 'reply title attribute', Reply.human_attribute_name('title')
  end

  def test_translated_model_attributes_with_sti_fallback
    I18n.backend.store_translations 'en', :activerecord => {:attributes => {:topic => {:title => 'topic title attribute'} } }
    assert_equal 'topic title attribute', Reply.human_attribute_name('title')
  end

  def test_translated_model_names
    I18n.backend.store_translations 'en', :activerecord => {:models => {:topic => 'topic model'} }
    assert_equal 'topic model', Topic.human_name
  end

  def test_translated_model_names_with_sti
    I18n.backend.store_translations 'en', :activerecord => {:models => {:reply => 'reply model'} }
    assert_equal 'reply model', Reply.human_name
  end

  def test_translated_model_names_with_sti_fallback
    I18n.backend.store_translations 'en', :activerecord => {:models => {:topic => 'topic model'} }
    assert_equal 'topic model', Reply.human_name
  end
end

