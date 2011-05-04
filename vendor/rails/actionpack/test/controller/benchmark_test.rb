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

# Provide some static controllers.
class BenchmarkedController < ActionController::Base
  def public_action
    render :nothing => true
  end

  def rescue_action(e)
    raise e
  end
end

class BenchmarkTest < ActionController::TestCase
  tests BenchmarkedController

  class MockLogger
    def method_missing(*args)
    end
  end

  def setup
    # benchmark doesn't do anything unless a logger is set
    @controller.logger = MockLogger.new
    @request.host = "test.actioncontroller.i"
  end

  def test_with_http_1_0_request
    @request.host = nil
    assert_nothing_raised { get :public_action }
  end
end
