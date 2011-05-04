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
      module Urumqi
        include TimezoneDefinition
        
        timezone 'Asia/Urumqi' do |tz|
          tz.offset :o0, 21020, 0, :LMT
          tz.offset :o1, 21600, 0, :URUT
          tz.offset :o2, 28800, 0, :CST
          tz.offset :o3, 28800, 3600, :CDT
          
          tz.transition 1927, 12, :o1, 10477063829, 4320
          tz.transition 1980, 4, :o2, 325965600
          tz.transition 1986, 5, :o3, 515520000
          tz.transition 1986, 9, :o2, 527007600
          tz.transition 1987, 4, :o3, 545155200
          tz.transition 1987, 9, :o2, 558457200
          tz.transition 1988, 4, :o3, 576604800
          tz.transition 1988, 9, :o2, 589906800
          tz.transition 1989, 4, :o3, 608659200
          tz.transition 1989, 9, :o2, 621961200
          tz.transition 1990, 4, :o3, 640108800
          tz.transition 1990, 9, :o2, 653410800
          tz.transition 1991, 4, :o3, 671558400
          tz.transition 1991, 9, :o2, 684860400
        end
      end
    end
  end
end
