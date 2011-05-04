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
      module Filters
        # Returns the string, first removing all whitespace on both ends of
        # the string, and then changing remaining consecutive whitespace
        # groups into one space each.
        #
        # Examples:
        #   %{ Multi-line
        #      string }.squish                   # => "Multi-line string"
        #   " foo   bar    \n   \t   boo".squish # => "foo bar boo"
        def squish
          dup.squish!
        end

        # Performs a destructive squish. See String#squish.
        def squish!
          strip!
          gsub!(/\s+/, ' ')
          self
        end
      end
    end
  end
end
