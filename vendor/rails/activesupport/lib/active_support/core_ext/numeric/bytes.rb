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
    module Numeric #:nodoc:
      # Enables the use of byte calculations and declarations, like 45.bytes + 2.6.megabytes
      module Bytes
        KILOBYTE = 1024
        MEGABYTE = KILOBYTE * 1024
        GIGABYTE = MEGABYTE * 1024
        TERABYTE = GIGABYTE * 1024
        PETABYTE = TERABYTE * 1024
        EXABYTE  = PETABYTE * 1024

        def bytes
          self
        end
        alias :byte :bytes

        def kilobytes
          self * KILOBYTE
        end
        alias :kilobyte :kilobytes

        def megabytes
          self * MEGABYTE
        end
        alias :megabyte :megabytes

        def gigabytes
          self * GIGABYTE
        end
        alias :gigabyte :gigabytes

        def terabytes
          self * TERABYTE
        end
        alias :terabyte :terabytes

        def petabytes
          self * PETABYTE
        end
        alias :petabyte :petabytes

        def exabytes
          self * EXABYTE
        end
        alias :exabyte :exabytes
      end
    end
  end
end
