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

module ActiveSupport
  module Cache
    # Like MemoryStore, but thread-safe.
    class SynchronizedMemoryStore < MemoryStore
      def initialize
        super
        @guard = Monitor.new
      end

      def fetch(key, options = {})
        @guard.synchronize { super }
      end

      def read(name, options = nil)
        @guard.synchronize { super }
      end

      def write(name, value, options = nil)
        @guard.synchronize { super }
      end

      def delete(name, options = nil)
        @guard.synchronize { super }
      end

      def delete_matched(matcher, options = nil)
        @guard.synchronize { super }
      end

      def exist?(name,options = nil)
        @guard.synchronize { super }
      end

      def increment(key, amount = 1)
        @guard.synchronize { super }
      end

      def decrement(key, amount = 1)
        @guard.synchronize { super }
      end

      def clear
        @guard.synchronize { super }
      end
    end
  end
end
