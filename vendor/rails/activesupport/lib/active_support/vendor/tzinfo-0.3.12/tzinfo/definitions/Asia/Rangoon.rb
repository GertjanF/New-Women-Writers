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
      module Rangoon
        include TimezoneDefinition
        
        timezone 'Asia/Rangoon' do |tz|
          tz.offset :o0, 23080, 0, :LMT
          tz.offset :o1, 23076, 0, :RMT
          tz.offset :o2, 23400, 0, :BURT
          tz.offset :o3, 32400, 0, :JST
          tz.offset :o4, 23400, 0, :MMT
          
          tz.transition 1879, 12, :o1, 5200664903, 2160
          tz.transition 1919, 12, :o2, 5813578159, 2400
          tz.transition 1942, 4, :o3, 116663051, 48
          tz.transition 1945, 5, :o4, 19452625, 8
        end
      end
    end
  end
end
