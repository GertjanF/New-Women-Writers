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
      module Pago_Pago
        include TimezoneDefinition
        
        timezone 'Pacific/Pago_Pago' do |tz|
          tz.offset :o0, 45432, 0, :LMT
          tz.offset :o1, -40968, 0, :LMT
          tz.offset :o2, -41400, 0, :SAMT
          tz.offset :o3, -39600, 0, :NST
          tz.offset :o4, -39600, 0, :BST
          tz.offset :o5, -39600, 0, :SST
          
          tz.transition 1879, 7, :o1, 2889041969, 1200
          tz.transition 1911, 1, :o2, 2902845569, 1200
          tz.transition 1950, 1, :o3, 116797583, 48
          tz.transition 1967, 4, :o4, 58549967, 24
          tz.transition 1983, 11, :o5, 439038000
        end
      end
    end
  end
end
