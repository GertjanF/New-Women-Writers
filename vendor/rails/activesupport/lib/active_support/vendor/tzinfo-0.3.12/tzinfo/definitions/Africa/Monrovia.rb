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
    module Africa
      module Monrovia
        include TimezoneDefinition
        
        timezone 'Africa/Monrovia' do |tz|
          tz.offset :o0, -2588, 0, :LMT
          tz.offset :o1, -2588, 0, :MMT
          tz.offset :o2, -2670, 0, :LRT
          tz.offset :o3, 0, 0, :GMT
          
          tz.transition 1882, 1, :o1, 52022445047, 21600
          tz.transition 1919, 3, :o2, 52315600247, 21600
          tz.transition 1972, 5, :o3, 73529070
        end
      end
    end
  end
end
