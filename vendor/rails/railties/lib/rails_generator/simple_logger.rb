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

module Rails
  module Generator
    class SimpleLogger # :nodoc:
      attr_reader :out
      attr_accessor :quiet

      def initialize(out = $stdout)
        @out = out
        @quiet = false
        @level = 0
      end

      def log(status, message, &block)
        @out.print("%12s  %s%s\n" % [status, '  ' * @level, message]) unless quiet
        indent(&block) if block_given?
      end

      def indent(&block)
        @level += 1
        if block_given?
          begin
            block.call
          ensure
            outdent
          end
        end
      end

      def outdent
        @level -= 1
        if block_given?
          begin
            block.call
          ensure
            indent
          end
        end
      end

      private
        def method_missing(method, *args, &block)
          log(method.to_s, args.first, &block)
        end
    end
  end
end
