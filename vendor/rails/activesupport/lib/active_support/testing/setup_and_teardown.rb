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

require 'active_support/callbacks'

module ActiveSupport
  module Testing
    module SetupAndTeardown
      def self.included(base)
        base.class_eval do
          include ActiveSupport::Callbacks
          define_callbacks :setup, :teardown

          if defined?(MiniTest::Assertions) && TestCase < MiniTest::Assertions
            include ForMiniTest
          else
            include ForClassicTestUnit
          end
        end
      end

      module ForMiniTest
        def run(runner)
          result = '.'
          begin
            run_callbacks :setup
            result = super
          rescue Exception => e
            result = runner.puke(self.class, self.name, e)
          ensure
            begin
              run_callbacks :teardown, :enumerator => :reverse_each
            rescue Exception => e
              result = runner.puke(self.class, self.name, e)
            end
          end
          result
        end
      end

      module ForClassicTestUnit
        # For compatibility with Ruby < 1.8.6
        PASSTHROUGH_EXCEPTIONS = Test::Unit::TestCase::PASSTHROUGH_EXCEPTIONS rescue [NoMemoryError, SignalException, Interrupt, SystemExit]

        # This redefinition is unfortunate but test/unit shows us no alternative.
        # Doubly unfortunate: hax to support Mocha's hax.
        def run(result)
          return if @method_name.to_s == "default_test"

          if using_mocha = respond_to?(:mocha_verify)
            assertion_counter_klass = if defined?(Mocha::TestCaseAdapter::AssertionCounter)
                                        Mocha::TestCaseAdapter::AssertionCounter
                                      else
                                        Mocha::Integration::TestUnit::AssertionCounter
                                      end
            assertion_counter = assertion_counter_klass.new(result)
          end

          yield(Test::Unit::TestCase::STARTED, name)
          @_result = result
          begin
            begin
              run_callbacks :setup
              setup
              __send__(@method_name)
              mocha_verify(assertion_counter) if using_mocha
            rescue Mocha::ExpectationError => e
              add_failure(e.message, e.backtrace)
            rescue Test::Unit::AssertionFailedError => e
              add_failure(e.message, e.backtrace)
            rescue Exception => e
              raise if PASSTHROUGH_EXCEPTIONS.include?(e.class)
              add_error(e)
            ensure
              begin
                teardown
                run_callbacks :teardown, :enumerator => :reverse_each
              rescue Test::Unit::AssertionFailedError => e
                add_failure(e.message, e.backtrace)
              rescue Exception => e
                raise if PASSTHROUGH_EXCEPTIONS.include?(e.class)
                add_error(e)
              end
            end
          ensure
            mocha_teardown if using_mocha
          end
          result.add_run
          yield(Test::Unit::TestCase::FINISHED, name)
        end
      end
    end
  end
end
