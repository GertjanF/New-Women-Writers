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
      module Caracas
        include TimezoneDefinition
        
        timezone 'America/Caracas' do |tz|
          tz.offset :o0, -16064, 0, :LMT
          tz.offset :o1, -16060, 0, :CMT
          tz.offset :o2, -16200, 0, :VET
          tz.offset :o3, -14400, 0, :VET
          
          tz.transition 1890, 1, :o1, 1627673863, 675
          tz.transition 1912, 2, :o2, 10452001043, 4320
          tz.transition 1965, 1, :o3, 39020187, 16
          tz.transition 2007, 12, :o2, 1197183600
        end
      end
    end
  end
end
