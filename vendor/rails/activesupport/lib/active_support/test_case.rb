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

require 'test/unit/testcase'
require 'active_support/testing/setup_and_teardown'
require 'active_support/testing/assertions'
require 'active_support/testing/deprecation'
require 'active_support/testing/declarative'

begin
  gem 'mocha', ">= 0.9.7"
  require 'mocha'
rescue LoadError
  # Fake Mocha::ExpectationError so we can rescue it in #run. Bleh.
  Object.const_set :Mocha, Module.new
  Mocha.const_set :ExpectationError, Class.new(StandardError)
end

module ActiveSupport
  class TestCase < ::Test::Unit::TestCase
    if defined? MiniTest
      Assertion = MiniTest::Assertion
      alias_method :method_name, :name if method_defined? :name
      alias_method :method_name, :__name__ if method_defined? :__name__
    else
      # TODO: Figure out how to get the Rails::BacktraceFilter into minitest/unit
      if defined?(Rails) && ENV['BACKTRACE'].nil?
        require 'rails/backtrace_cleaner'
        Test::Unit::Util::BacktraceFilter.module_eval { include Rails::BacktraceFilterForTestUnit }
      end

      Assertion = Test::Unit::AssertionFailedError

      require 'active_support/testing/default'
      include ActiveSupport::Testing::Default
    end

    include ActiveSupport::Testing::SetupAndTeardown
    include ActiveSupport::Testing::Assertions
    include ActiveSupport::Testing::Deprecation
    extend ActiveSupport::Testing::Declarative
  end
end
