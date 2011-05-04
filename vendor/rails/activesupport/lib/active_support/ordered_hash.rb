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

# OrderedHash is namespaced to prevent conflicts with other implementations
module ActiveSupport
  # Hash is ordered in Ruby 1.9!
  if RUBY_VERSION >= '1.9'
    OrderedHash = ::Hash
  else
    class OrderedHash < Hash #:nodoc:
      def initialize(*args, &block)
        super
        @keys = []
      end

      def self.[](*args)
        ordered_hash = new

        if (args.length == 1 && args.first.is_a?(Array))
          args.first.each do |key_value_pair|
            next unless (key_value_pair.is_a?(Array))
            ordered_hash[key_value_pair[0]] = key_value_pair[1]
          end

          return ordered_hash
        end

        unless (args.size % 2 == 0)
          raise ArgumentError.new("odd number of arguments for Hash")
        end

        args.each_with_index do |val, ind|
          next if (ind % 2 != 0)
          ordered_hash[val] = args[ind + 1]
        end

        ordered_hash
      end

      def initialize_copy(other)
        super
        # make a deep copy of keys
        @keys = other.keys
      end

      def []=(key, value)
        @keys << key if !has_key?(key)
        super
      end

      def delete(key)
        if has_key? key
          index = @keys.index(key)
          @keys.delete_at index
        end
        super
      end
      
      def delete_if
        super
        sync_keys!
        self
      end

      def reject!
        super
        sync_keys!
        self
      end

      def reject(&block)
        dup.reject!(&block)
      end

      def keys
        @keys.dup
      end

      def values
        @keys.collect { |key| self[key] }
      end

      def to_hash
        self
      end

      def to_a
        @keys.map { |key| [ key, self[key] ] }
      end

      def each_key
        @keys.each { |key| yield key }
      end

      def each_value
        @keys.each { |key| yield self[key]}
      end

      def each
        @keys.each {|key| yield [key, self[key]]}
      end

      alias_method :each_pair, :each

      def clear
        super
        @keys.clear
        self
      end

      def shift
        k = @keys.first
        v = delete(k)
        [k, v]
      end

      def merge!(other_hash)
        other_hash.each {|k,v| self[k] = v }
        self
      end

      def merge(other_hash)
        dup.merge!(other_hash)
      end

      def inspect
        "#<OrderedHash #{super}>"
      end

    private

      def sync_keys!
        @keys.delete_if {|k| !has_key?(k)}
      end
    end
  end
end
