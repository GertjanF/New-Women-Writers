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
      module Port_Moresby
        include TimezoneDefinition
        
        timezone 'Pacific/Port_Moresby' do |tz|
          tz.offset :o0, 35320, 0, :LMT
          tz.offset :o1, 35312, 0, :PMMT
          tz.offset :o2, 36000, 0, :PGT
          
          tz.transition 1879, 12, :o1, 5200664597, 2160
          tz.transition 1894, 12, :o2, 13031248093, 5400
        end
      end
    end
  end
end
