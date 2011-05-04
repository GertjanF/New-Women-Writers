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
      module Kabul
        include TimezoneDefinition
        
        timezone 'Asia/Kabul' do |tz|
          tz.offset :o0, 16608, 0, :LMT
          tz.offset :o1, 14400, 0, :AFT
          tz.offset :o2, 16200, 0, :AFT
          
          tz.transition 1889, 12, :o1, 2170231477, 900
          tz.transition 1944, 12, :o2, 7294369, 3
        end
      end
    end
  end
end
