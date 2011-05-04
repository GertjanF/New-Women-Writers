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
    module String #:nodoc:
      unless '1.9'.respond_to?(:force_encoding)
        # Makes it easier to access parts of a string, such as specific characters and substrings.
        module Access
          # Returns the character at the +position+ treating the string as an array (where 0 is the first character).
          #
          # Examples: 
          #   "hello".at(0)  # => "h"
          #   "hello".at(4)  # => "o"
          #   "hello".at(10) # => nil
          def at(position)
            mb_chars[position, 1].to_s
          end
          
          # Returns the remaining of the string from the +position+ treating the string as an array (where 0 is the first character).
          #
          # Examples: 
          #   "hello".from(0)  # => "hello"
          #   "hello".from(2)  # => "llo"
          #   "hello".from(10) # => nil
          def from(position)
            mb_chars[position..-1].to_s
          end
          
          # Returns the beginning of the string up to the +position+ treating the string as an array (where 0 is the first character).
          #
          # Examples: 
          #   "hello".to(0)  # => "h"
          #   "hello".to(2)  # => "hel"
          #   "hello".to(10) # => "hello"
          def to(position)
            mb_chars[0..position].to_s
          end

          # Returns the first character of the string or the first +limit+ characters.
          #
          # Examples: 
          #   "hello".first     # => "h"
          #   "hello".first(2)  # => "he"
          #   "hello".first(10) # => "hello"
          def first(limit = 1)
            if limit == 0
              ''
            elsif limit >= size
              self
            else
              mb_chars[0...limit].to_s
            end
          end

          # Returns the last character of the string or the last +limit+ characters.
          #
          # Examples: 
          #   "hello".last     # => "o"
          #   "hello".last(2)  # => "lo"
          #   "hello".last(10) # => "hello"
          def last(limit = 1)
            if limit == 0
              ''
            elsif limit >= size
              self
            else
              mb_chars[(-limit)..-1].to_s
            end
          end
        end
      else
        module Access #:nodoc:
          def at(position)
            self[position]
          end

          def from(position)
            self[position..-1]
          end

          def to(position)
            self[0..position]
          end

          def first(limit = 1)
            if limit == 0
              ''
            elsif limit >= size
              self
            else
              to(limit - 1)
            end
          end

          def last(limit = 1)
            if limit == 0
              ''
            elsif limit >= size
              self
            else
              from(-limit)
            end
          end
        end
      end
    end
  end
end
