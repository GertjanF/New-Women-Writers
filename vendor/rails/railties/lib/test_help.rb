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

# Make double-sure the RAILS_ENV is set to test,
# so fixtures are loaded to the right database
silence_warnings { RAILS_ENV = "test" }

require 'test/unit'
require 'action_controller/test_case'
require 'action_view/test_case'
require 'action_controller/integration'
require 'action_mailer/test_case' if defined?(ActionMailer)

if defined?(ActiveRecord)
  require 'active_record/test_case'
  require 'active_record/fixtures'

  class ActiveSupport::TestCase
    include ActiveRecord::TestFixtures
    self.fixture_path = "#{RAILS_ROOT}/test/fixtures/"
    self.use_instantiated_fixtures  = false
    self.use_transactional_fixtures = true
  end

  ActionController::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path

  def create_fixtures(*table_names, &block)
    Fixtures.create_fixtures(ActiveSupport::TestCase.fixture_path, table_names, {}, &block)
  end
end

begin
  require_library_or_gem 'ruby-debug'
  Debugger.start
  if Debugger.respond_to?(:settings)
    Debugger.settings[:autoeval] = true
    Debugger.settings[:autolist] = 1
  end
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
end
