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

module PeopleHelper
  def title(text)
    content_tag(:h1, text)
  end

  def homepage_path
    people_path
  end

  def homepage_url
    people_url
  end

  def link_to_person(person)
    link_to person.name, person
  end
end

class PeopleHelperTest < ActionView::TestCase
  def setup
    ActionController::Routing::Routes.draw do |map|
      map.people 'people', :controller => 'people', :action => 'index'
      map.connect ':controller/:action/:id'
    end
  end

  def test_title
    assert_equal "<h1>Ruby on Rails</h1>", title("Ruby on Rails")
  end

  def test_homepage_path
    assert_equal "/people", homepage_path
  end

  def test_homepage_url
    assert_equal "http://test.host/people", homepage_url
  end

  def test_link_to_person
    person = mock(:name => "David")
    expects(:mocha_mock_path).with(person).returns("/people/1")
    assert_equal '<a href="/people/1">David</a>', link_to_person(person)
  end
end

class CrazyHelperTest < ActionView::TestCase
  tests PeopleHelper

  def test_helper_class_can_be_set_manually_not_just_inferred
    assert_equal PeopleHelper, self.class.helper_class
  end
end
