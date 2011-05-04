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
      module Keys
        # Return a new hash with all keys converted to strings.
        def stringify_keys
          inject({}) do |options, (key, value)|
            options[key.to_s] = value
            options
          end
        end

        # Destructively convert all keys to strings.
        def stringify_keys!
          keys.each do |key|
            self[key.to_s] = delete(key)
          end
          self
        end

        # Return a new hash with all keys converted to symbols.
        def symbolize_keys
          inject({}) do |options, (key, value)|
            options[(key.to_sym rescue key) || key] = value
            options
          end
        end

        # Destructively convert all keys to symbols.
        def symbolize_keys!
          self.replace(self.symbolize_keys)
        end

        alias_method :to_options,  :symbolize_keys
        alias_method :to_options!, :symbolize_keys!

        # Validate all keys in a hash match *valid keys, raising ArgumentError on a mismatch.
        # Note that keys are NOT treated indifferently, meaning if you use strings for keys but assert symbols
        # as keys, this will fail.
        #
        # ==== Examples
        #   { :name => "Rob", :years => "28" }.assert_valid_keys(:name, :age) # => raises "ArgumentError: Unknown key(s): years"
        #   { :name => "Rob", :age => "28" }.assert_valid_keys("name", "age") # => raises "ArgumentError: Unknown key(s): name, age"
        #   { :name => "Rob", :age => "28" }.assert_valid_keys(:name, :age) # => passes, raises nothing
        def assert_valid_keys(*valid_keys)
          unknown_keys = keys - [valid_keys].flatten
          raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}") unless unknown_keys.empty?
        end
      end
    end
  end
end
