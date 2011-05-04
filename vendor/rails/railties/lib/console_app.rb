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

require 'active_support/test_case'
require 'action_controller'

# work around the at_exit hook in test/unit, which kills IRB
Test::Unit.run = true if Test::Unit.respond_to?(:run=)

# reference the global "app" instance, created on demand. To recreate the
# instance, pass a non-false value as the parameter.
def app(create=false)
  @app_integration_instance = nil if create
  @app_integration_instance ||= new_session do |sess|
    sess.host! "www.example.com"
  end
end

# create a new session. If a block is given, the new session will be yielded
# to the block before being returned.
def new_session
  session = ActionController::Integration::Session.new
  yield session if block_given?
  session
end

#reloads the environment
def reload!
  puts "Reloading..."
  Dispatcher.cleanup_application
  Dispatcher.reload_application
  true
end
