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
      module Fiji
        include TimezoneDefinition
        
        timezone 'Pacific/Fiji' do |tz|
          tz.offset :o0, 42820, 0, :LMT
          tz.offset :o1, 43200, 0, :FJT
          tz.offset :o2, 43200, 3600, :FJST
          
          tz.transition 1915, 10, :o1, 10457838739, 4320
          tz.transition 1998, 10, :o2, 909842400
          tz.transition 1999, 2, :o1, 920124000
          tz.transition 1999, 11, :o2, 941896800
          tz.transition 2000, 2, :o1, 951573600
        end
      end
    end
  end
end
