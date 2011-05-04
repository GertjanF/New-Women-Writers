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

require 'strscan'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module String #:nodoc:
      # Custom string iterators
      module Iterators
        def self.append_features(base)
          super unless '1.9'.respond_to?(:each_char)
        end

        # Yields a single-character string for each character in the string.
        # When $KCODE = 'UTF8', multi-byte characters are yielded appropriately.
        def each_char
          scanner, char = StringScanner.new(self), /./mu
          while c = scanner.scan(char)
            yield c
          end
        end
      end
    end
  end
end
