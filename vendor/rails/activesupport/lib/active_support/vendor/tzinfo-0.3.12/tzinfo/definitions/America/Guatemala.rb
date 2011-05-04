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
      module Guatemala
        include TimezoneDefinition
        
        timezone 'America/Guatemala' do |tz|
          tz.offset :o0, -21724, 0, :LMT
          tz.offset :o1, -21600, 0, :CST
          tz.offset :o2, -21600, 3600, :CDT
          
          tz.transition 1918, 10, :o1, 52312429831, 21600
          tz.transition 1973, 11, :o2, 123055200
          tz.transition 1974, 2, :o1, 130914000
          tz.transition 1983, 5, :o2, 422344800
          tz.transition 1983, 9, :o1, 433054800
          tz.transition 1991, 3, :o2, 669708000
          tz.transition 1991, 9, :o1, 684219600
          tz.transition 2006, 4, :o2, 1146376800
          tz.transition 2006, 10, :o1, 1159678800
        end
      end
    end
  end
end
