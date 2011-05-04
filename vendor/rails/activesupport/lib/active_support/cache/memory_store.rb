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
    # A cache store implementation which stores everything into memory in the
    # same process. If you're running multiple Ruby on Rails server processes
    # (which is the case if you're using mongrel_cluster or Phusion Passenger),
    # then this means that your Rails server process instances won't be able
    # to share cache data with each other. If your application never performs
    # manual cache item expiry (e.g. when you're using generational cache keys),
    # then using MemoryStore is ok. Otherwise, consider carefully whether you
    # should be using this cache store.
    #
    # MemoryStore is not only able to store strings, but also arbitrary Ruby
    # objects.
    #
    # MemoryStore is not thread-safe. Use SynchronizedMemoryStore instead
    # if you need thread-safety.
    class MemoryStore < Store
      def initialize
        @data = {}
      end

      def read(name, options = nil)
        super
        @data[name]
      end

      def write(name, value, options = nil)
        super
        @data[name] = value.freeze
      end

      def delete(name, options = nil)
        super
        @data.delete(name)
      end

      def delete_matched(matcher, options = nil)
        super
        @data.delete_if { |k,v| k =~ matcher }
      end

      def exist?(name,options = nil)
        super
        @data.has_key?(name)
      end

      def clear
        @data.clear
      end
    end
  end
end
