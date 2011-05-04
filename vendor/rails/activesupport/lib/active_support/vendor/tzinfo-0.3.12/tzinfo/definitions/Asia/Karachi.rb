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
      module Karachi
        include TimezoneDefinition
        
        timezone 'Asia/Karachi' do |tz|
          tz.offset :o0, 16092, 0, :LMT
          tz.offset :o1, 19800, 0, :IST
          tz.offset :o2, 19800, 3600, :IST
          tz.offset :o3, 18000, 0, :KART
          tz.offset :o4, 18000, 0, :PKT
          tz.offset :o5, 18000, 3600, :PKST
          
          tz.transition 1906, 12, :o1, 1934061051, 800
          tz.transition 1942, 8, :o2, 116668957, 48
          tz.transition 1945, 10, :o1, 116723675, 48
          tz.transition 1951, 9, :o3, 116828125, 48
          tz.transition 1971, 3, :o4, 38775600
          tz.transition 2002, 4, :o5, 1018119660
          tz.transition 2002, 10, :o4, 1033840860
          tz.transition 2008, 5, :o5, 1212260400
          tz.transition 2008, 10, :o4, 1225476000
        end
      end
    end
  end
end
