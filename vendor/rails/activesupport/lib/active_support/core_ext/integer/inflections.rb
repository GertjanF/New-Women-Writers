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

require 'active_support/inflector'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Integer #:nodoc:
      module Inflections
        # Ordinalize turns a number into an ordinal string used to denote the
        # position in an ordered sequence such as 1st, 2nd, 3rd, 4th.
        #
        #   1.ordinalize    # => "1st"
        #   2.ordinalize    # => "2nd"
        #   1002.ordinalize # => "1002nd"
        #   1003.ordinalize # => "1003rd"
        def ordinalize
          Inflector.ordinalize(self)
        end
      end
    end
  end
end
