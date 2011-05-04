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
      module Dhaka
        include TimezoneDefinition
        
        timezone 'Asia/Dhaka' do |tz|
          tz.offset :o0, 21700, 0, :LMT
          tz.offset :o1, 21200, 0, :HMT
          tz.offset :o2, 23400, 0, :BURT
          tz.offset :o3, 19800, 0, :IST
          tz.offset :o4, 21600, 0, :DACT
          tz.offset :o5, 21600, 0, :BDT
          
          tz.transition 1889, 12, :o1, 2083422167, 864
          tz.transition 1941, 9, :o2, 524937943, 216
          tz.transition 1942, 5, :o3, 116663723, 48
          tz.transition 1942, 8, :o2, 116668957, 48
          tz.transition 1951, 9, :o4, 116828123, 48
          tz.transition 1971, 3, :o5, 38772000
        end
      end
    end
  end
end
