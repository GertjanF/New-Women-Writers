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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Slice a hash to include only the given keys. This is useful for
      # limiting an options hash to valid keys before passing to a method:
      #
      #   def search(criteria = {})
      #     assert_valid_keys(:mass, :velocity, :time)
      #   end
      #
      #   search(options.slice(:mass, :velocity, :time))
      #
      # If you have an array of keys you want to limit to, you should splat them:
      #
      #   valid_keys = [:mass, :velocity, :time]
      #   search(options.slice(*valid_keys))
      module Slice
        # Returns a new hash with only the given keys.
        def slice(*keys)
          keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
          hash = self.class.new
          keys.each { |k| hash[k] = self[k] if has_key?(k) }
          hash
        end

        # Replaces the hash with only the given keys.
        # Returns a hash contained the removed key/value pairs
        #   {:a => 1, :b => 2, :c => 3, :d => 4}.slice!(:a, :b) # => {:c => 3, :d =>4}
        def slice!(*keys)
          keys = keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
          omit = slice(*self.keys - keys)
          hash = slice(*keys)
          replace(hash)
          omit
        end
      end
    end
  end
end

