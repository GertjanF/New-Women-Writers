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
    module Asia
      module Jakarta
        include TimezoneDefinition
        
        timezone 'Asia/Jakarta' do |tz|
          tz.offset :o0, 25632, 0, :LMT
          tz.offset :o1, 25632, 0, :JMT
          tz.offset :o2, 26400, 0, :JAVT
          tz.offset :o3, 27000, 0, :WIT
          tz.offset :o4, 32400, 0, :JST
          tz.offset :o5, 28800, 0, :WIT
          tz.offset :o6, 25200, 0, :WIT
          
          tz.transition 1867, 8, :o1, 720956461, 300
          tz.transition 1923, 12, :o2, 87256267, 36
          tz.transition 1932, 10, :o3, 87372439, 36
          tz.transition 1942, 3, :o4, 38887059, 16
          tz.transition 1945, 9, :o3, 19453769, 8
          tz.transition 1948, 4, :o5, 38922755, 16
          tz.transition 1950, 4, :o3, 14600413, 6
          tz.transition 1963, 12, :o6, 39014323, 16
        end
      end
    end
  end
end
