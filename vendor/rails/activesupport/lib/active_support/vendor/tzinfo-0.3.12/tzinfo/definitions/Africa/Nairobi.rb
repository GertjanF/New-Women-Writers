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

require 'tzinfo/timezone_definition'

module TZInfo
  module Definitions
    module Africa
      module Nairobi
        include TimezoneDefinition
        
        timezone 'Africa/Nairobi' do |tz|
          tz.offset :o0, 8836, 0, :LMT
          tz.offset :o1, 10800, 0, :EAT
          tz.offset :o2, 9000, 0, :BEAT
          tz.offset :o3, 9885, 0, :BEAUT
          
          tz.transition 1928, 6, :o1, 52389253391, 21600
          tz.transition 1929, 12, :o2, 19407819, 8
          tz.transition 1939, 12, :o3, 116622211, 48
          tz.transition 1959, 12, :o1, 14036742061, 5760
        end
      end
    end
  end
end
