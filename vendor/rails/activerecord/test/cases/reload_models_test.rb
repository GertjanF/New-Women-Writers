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
require 'models/owner'
require 'models/pet'

class ReloadModelsTest < ActiveRecord::TestCase
  fixtures :pets

  def test_has_one_with_reload
    pet = Pet.find_by_name('parrot')
    pet.owner = Owner.find_by_name('ashley')

    # Reload the class Owner, simulating auto-reloading of model classes in a
    # development environment. Note that meanwhile the class Pet is not
    # reloaded, simulating a class that is present in a plugin.
    Object.class_eval { remove_const :Owner }
    Kernel.load(File.expand_path(File.join(File.dirname(__FILE__), "../models/owner.rb")))

    pet = Pet.find_by_name('parrot')
    pet.owner = Owner.find_by_name('ashley')
    assert_equal pet.owner, Owner.find_by_name('ashley')
  end
end
