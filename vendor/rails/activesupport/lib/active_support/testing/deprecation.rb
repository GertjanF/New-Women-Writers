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

require "active_support/core_ext/module"

module ActiveSupport
  module Testing
    module Deprecation #:nodoc:
      def assert_deprecated(match = nil, &block)
        result, warnings = collect_deprecations(&block)
        assert !warnings.empty?, "Expected a deprecation warning within the block but received none"
        if match
          match = Regexp.new(Regexp.escape(match)) unless match.is_a?(Regexp)
          assert warnings.any? { |w| w =~ match }, "No deprecation warning matched #{match}: #{warnings.join(', ')}"
        end
        result
      end

      def assert_not_deprecated(&block)
        result, deprecations = collect_deprecations(&block)
        assert deprecations.empty?, "Expected no deprecation warning within the block but received #{deprecations.size}: \n  #{deprecations * "\n  "}"
        result
      end

      private
        def collect_deprecations
          old_behavior = ActiveSupport::Deprecation.behavior
          deprecations = []
          ActiveSupport::Deprecation.behavior = Proc.new do |message, callstack|
            deprecations << message
          end
          result = yield
          [result, deprecations]
        ensure
          ActiveSupport::Deprecation.behavior = old_behavior
        end
    end
  end
end

begin
  require 'test/unit/error'

  module Test
    module Unit
      class Error # :nodoc:
        # Silence warnings when reporting test errors.
        def message_with_silenced_deprecation
          ActiveSupport::Deprecation.silence do
            message_without_silenced_deprecation
          end
        end

        alias_method_chain :message, :silenced_deprecation
      end
    end
  end
rescue LoadError
  # Using miniunit, ignore.
end
