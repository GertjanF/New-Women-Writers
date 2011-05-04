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
    module Pacific
      module Tongatapu
        include TimezoneDefinition
        
        timezone 'Pacific/Tongatapu' do |tz|
          tz.offset :o0, 44360, 0, :LMT
          tz.offset :o1, 44400, 0, :TOT
          tz.offset :o2, 46800, 0, :TOT
          tz.offset :o3, 46800, 3600, :TOST
          
          tz.transition 1900, 12, :o1, 5217231571, 2160
          tz.transition 1940, 12, :o2, 174959639, 72
          tz.transition 1999, 10, :o3, 939214800
          tz.transition 2000, 3, :o2, 953384400
          tz.transition 2000, 11, :o3, 973342800
          tz.transition 2001, 1, :o2, 980596800
          tz.transition 2001, 11, :o3, 1004792400
          tz.transition 2002, 1, :o2, 1012046400
        end
      end
    end
  end
end
