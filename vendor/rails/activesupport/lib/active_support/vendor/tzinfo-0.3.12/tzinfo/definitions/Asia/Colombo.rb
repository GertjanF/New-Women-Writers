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
      module Colombo
        include TimezoneDefinition
        
        timezone 'Asia/Colombo' do |tz|
          tz.offset :o0, 19164, 0, :LMT
          tz.offset :o1, 19172, 0, :MMT
          tz.offset :o2, 19800, 0, :IST
          tz.offset :o3, 19800, 1800, :IHST
          tz.offset :o4, 19800, 3600, :IST
          tz.offset :o5, 23400, 0, :LKT
          tz.offset :o6, 21600, 0, :LKT
          
          tz.transition 1879, 12, :o1, 17335550003, 7200
          tz.transition 1905, 12, :o2, 52211763607, 21600
          tz.transition 1942, 1, :o3, 116657485, 48
          tz.transition 1942, 8, :o4, 9722413, 4
          tz.transition 1945, 10, :o2, 38907909, 16
          tz.transition 1996, 5, :o5, 832962600
          tz.transition 1996, 10, :o6, 846266400
          tz.transition 2006, 4, :o2, 1145039400
        end
      end
    end
  end
end
