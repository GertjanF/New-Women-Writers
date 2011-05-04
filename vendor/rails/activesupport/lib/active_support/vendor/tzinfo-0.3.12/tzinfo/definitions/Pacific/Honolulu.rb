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
      module Honolulu
        include TimezoneDefinition
        
        timezone 'Pacific/Honolulu' do |tz|
          tz.offset :o0, -37886, 0, :LMT
          tz.offset :o1, -37800, 0, :HST
          tz.offset :o2, -37800, 3600, :HDT
          tz.offset :o3, -37800, 3600, :HWT
          tz.offset :o4, -37800, 3600, :HPT
          tz.offset :o5, -36000, 0, :HST
          
          tz.transition 1900, 1, :o1, 104328926143, 43200
          tz.transition 1933, 4, :o2, 116505265, 48
          tz.transition 1933, 5, :o1, 116506271, 48
          tz.transition 1942, 2, :o3, 116659201, 48
          tz.transition 1945, 8, :o4, 58360379, 24
          tz.transition 1945, 9, :o1, 116722991, 48
          tz.transition 1947, 6, :o5, 116752561, 48
        end
      end
    end
  end
end
