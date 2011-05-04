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
    module America
      module Lima
        include TimezoneDefinition
        
        timezone 'America/Lima' do |tz|
          tz.offset :o0, -18492, 0, :LMT
          tz.offset :o1, -18516, 0, :LMT
          tz.offset :o2, -18000, 0, :PET
          tz.offset :o3, -18000, 3600, :PEST
          
          tz.transition 1890, 1, :o1, 17361854741, 7200
          tz.transition 1908, 7, :o2, 17410685143, 7200
          tz.transition 1938, 1, :o3, 58293593, 24
          tz.transition 1938, 4, :o2, 7286969, 3
          tz.transition 1938, 9, :o3, 58300001, 24
          tz.transition 1939, 3, :o2, 7288046, 3
          tz.transition 1939, 9, :o3, 58308737, 24
          tz.transition 1940, 3, :o2, 7289138, 3
          tz.transition 1986, 1, :o3, 504939600
          tz.transition 1986, 4, :o2, 512712000
          tz.transition 1987, 1, :o3, 536475600
          tz.transition 1987, 4, :o2, 544248000
          tz.transition 1990, 1, :o3, 631170000
          tz.transition 1990, 4, :o2, 638942400
          tz.transition 1994, 1, :o3, 757400400
          tz.transition 1994, 4, :o2, 765172800
        end
      end
    end
  end
end
