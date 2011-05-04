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
require 'models/post'
require 'models/comment'
require 'models/project'
require 'models/developer'
require 'models/company_in_module'

class AssociationsExtensionsTest < ActiveRecord::TestCase
  fixtures :projects, :developers, :developers_projects, :comments, :posts

  def test_extension_on_has_many
    assert_equal comments(:more_greetings), posts(:welcome).comments.find_most_recent
  end

  def test_extension_on_habtm
    assert_equal projects(:action_controller), developers(:david).projects.find_most_recent
  end

  def test_named_extension_on_habtm
    assert_equal projects(:action_controller), developers(:david).projects_extended_by_name.find_most_recent
  end

  def test_named_two_extensions_on_habtm
    assert_equal projects(:action_controller), developers(:david).projects_extended_by_name_twice.find_most_recent
    assert_equal projects(:active_record), developers(:david).projects_extended_by_name_twice.find_least_recent
  end

  def test_named_extension_and_block_on_habtm
    assert_equal projects(:action_controller), developers(:david).projects_extended_by_name_and_block.find_most_recent
    assert_equal projects(:active_record), developers(:david).projects_extended_by_name_and_block.find_least_recent
  end

  def test_marshalling_extensions
    david = developers(:david)
    assert_equal projects(:action_controller), david.projects.find_most_recent

    david = Marshal.load(Marshal.dump(david))
    assert_equal projects(:action_controller), david.projects.find_most_recent
  end

  def test_marshalling_named_extensions
    david = developers(:david)
    assert_equal projects(:action_controller), david.projects_extended_by_name.find_most_recent

    david = Marshal.load(Marshal.dump(david))
    assert_equal projects(:action_controller), david.projects_extended_by_name.find_most_recent
  end


	def test_extension_name
	  extension = Proc.new {}
	  name = :association_name

	  assert_equal 'DeveloperAssociationNameAssociationExtension', Developer.send(:create_extension_modules, name, extension, []).first.name
	  assert_equal 'MyApplication::Business::DeveloperAssociationNameAssociationExtension',
MyApplication::Business::Developer.send(:create_extension_modules, name, extension, []).first.name
    assert_equal 'MyApplication::Business::DeveloperAssociationNameAssociationExtension', MyApplication::Business::Developer.send(:create_extension_modules, name, extension, []).first.name
    assert_equal 'MyApplication::Business::DeveloperAssociationNameAssociationExtension', MyApplication::Business::Developer.send(:create_extension_modules, name, extension, []).first.name
  end


end
