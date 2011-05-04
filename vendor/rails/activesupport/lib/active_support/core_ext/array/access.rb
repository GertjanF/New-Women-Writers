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
    module Array #:nodoc:
      # Makes it easier to access parts of an array.
      module Access
        # Returns the tail of the array from +position+.
        #
        #   %w( a b c d ).from(0)  # => %w( a b c d )
        #   %w( a b c d ).from(2)  # => %w( c d )
        #   %w( a b c d ).from(10) # => nil
        #   %w().from(0)           # => nil
        def from(position)
          self[position..-1]
        end
        
        # Returns the beginning of the array up to +position+.
        #
        #   %w( a b c d ).to(0)  # => %w( a )
        #   %w( a b c d ).to(2)  # => %w( a b c )
        #   %w( a b c d ).to(10) # => %w( a b c d )
        #   %w().to(0)           # => %w()
        def to(position)
          self[0..position]
        end

        # Equal to <tt>self[1]</tt>.
        def second
          self[1]
        end

        # Equal to <tt>self[2]</tt>.
        def third
          self[2]
        end

        # Equal to <tt>self[3]</tt>.
        def fourth
          self[3]
        end

        # Equal to <tt>self[4]</tt>.
        def fifth
          self[4]
        end

        # Equal to <tt>self[41]</tt>. Also known as accessing "the reddit".
        def forty_two
          self[41]
        end
      end
    end
  end
end
