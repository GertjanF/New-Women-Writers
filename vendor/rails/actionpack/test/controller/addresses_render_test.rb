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

class Address
  def Address.count(conditions = nil, join = nil)
    nil
  end

  def Address.find_all(arg1, arg2, arg3, arg4)
    []
  end

  def self.find(*args)
    []
  end
end

class AddressesTestController < ActionController::Base
  def self.controller_name; "addresses"; end
  def self.controller_path; "addresses"; end
end

class AddressesTest < ActionController::TestCase
  tests AddressesTestController

  def setup
    # enable a logger so that (e.g.) the benchmarking stuff runs, so we can get
    # a more accurate simulation of what happens in "real life".
    @controller.logger = Logger.new(nil)

    @request.host = "www.nextangle.com"
  end

  def test_list
    get :list
    assert_equal "We only need to get this far!", @response.body.chomp
  end
end
