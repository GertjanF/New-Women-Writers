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
    module Base64 #:nodoc:
      module Encoding
        # Encodes the value as base64 without the newline breaks. This makes the base64 encoding readily usable as URL parameters 
        # or memcache keys without further processing.
        #
        #  ActiveSupport::Base64.encode64s("Original unencoded string") 
        #  # => "T3JpZ2luYWwgdW5lbmNvZGVkIHN0cmluZw=="
        def encode64s(value)
          encode64(value).gsub(/\n/, '')
        end
      end
    end
  end
end
