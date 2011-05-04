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
    module Australia
      module Darwin
        include TimezoneDefinition
        
        timezone 'Australia/Darwin' do |tz|
          tz.offset :o0, 31400, 0, :LMT
          tz.offset :o1, 32400, 0, :CST
          tz.offset :o2, 34200, 0, :CST
          tz.offset :o3, 34200, 3600, :CST
          
          tz.transition 1895, 1, :o1, 1042513259, 432
          tz.transition 1899, 4, :o2, 19318201, 8
          tz.transition 1916, 12, :o3, 3486569911, 1440
          tz.transition 1917, 3, :o2, 116222983, 48
          tz.transition 1941, 12, :o3, 38885763, 16
          tz.transition 1942, 3, :o2, 116661463, 48
          tz.transition 1942, 9, :o3, 38890067, 16
          tz.transition 1943, 3, :o2, 116678935, 48
          tz.transition 1943, 10, :o3, 38896003, 16
          tz.transition 1944, 3, :o2, 116696407, 48
        end
      end
    end
  end
end
