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
    module Integer #:nodoc:
      # For checking if a fixnum is even or odd.
      #
      #   2.even?  # => true
      #   2.odd?   # => false
      #   1.even?  # => false
      #   1.odd?   # => true
      #   0.even?  # => true
      #   0.odd?   # => false
      #   -1.even? # => false
      #   -1.odd?  # => true
      module EvenOdd
        def multiple_of?(number)
          self % number == 0
        end

        def even?
          multiple_of? 2
        end if RUBY_VERSION < '1.9'

        def odd?
          !even?
        end if RUBY_VERSION < '1.9'
      end
    end
  end
end
