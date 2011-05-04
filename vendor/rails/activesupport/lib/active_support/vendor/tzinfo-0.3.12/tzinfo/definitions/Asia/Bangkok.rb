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
      module Bangkok
        include TimezoneDefinition
        
        timezone 'Asia/Bangkok' do |tz|
          tz.offset :o0, 24124, 0, :LMT
          tz.offset :o1, 24124, 0, :BMT
          tz.offset :o2, 25200, 0, :ICT
          
          tz.transition 1879, 12, :o1, 52006648769, 21600
          tz.transition 1920, 3, :o2, 52324168769, 21600
        end
      end
    end
  end
end
