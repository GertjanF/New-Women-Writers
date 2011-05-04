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
      module Conversions
        # Assumes self represents an offset from UTC in seconds (as returned from Time#utc_offset)
        # and turns this into an +HH:MM formatted string. Example:
        #
        #   -21_600.to_utc_offset_s   # => "-06:00"
        def to_utc_offset_s(colon=true)
          seconds = self
          sign = (seconds < 0 ? -1 : 1)
          hours = seconds.abs / 3600
          minutes = (seconds.abs % 3600) / 60
          "%+03d%s%02d" % [ hours * sign, colon ? ":" : "", minutes ]
        end
      end
    end
  end
end
