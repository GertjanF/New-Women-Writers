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

class ConnectionManagementTest < ActiveRecord::TestCase
  def setup
    @env = {}
    @app = stub('App')
    @management = ActiveRecord::ConnectionAdapters::ConnectionManagement.new(@app)
    
    @connections_cleared = false
    ActiveRecord::Base.stubs(:clear_active_connections!).with { @connections_cleared = true }
  end
  
  test "clears active connections after each call" do
    @app.expects(:call).with(@env)
    @management.call(@env)
    assert @connections_cleared
  end
  
  test "doesn't clear active connections when running in a test case" do
    @env['rack.test'] = true
    @app.expects(:call).with(@env)
    @management.call(@env)
    assert !@connections_cleared
  end
end