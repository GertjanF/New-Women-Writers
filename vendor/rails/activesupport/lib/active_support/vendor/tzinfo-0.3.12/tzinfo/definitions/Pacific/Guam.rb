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
    module Pacific
      module Guam
        include TimezoneDefinition
        
        timezone 'Pacific/Guam' do |tz|
          tz.offset :o0, -51660, 0, :LMT
          tz.offset :o1, 34740, 0, :LMT
          tz.offset :o2, 36000, 0, :GST
          tz.offset :o3, 36000, 0, :ChST
          
          tz.transition 1844, 12, :o1, 1149567407, 480
          tz.transition 1900, 12, :o2, 1159384847, 480
          tz.transition 2000, 12, :o3, 977493600
        end
      end
    end
  end
end
