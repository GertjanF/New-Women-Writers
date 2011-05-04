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

require 'active_support/core_ext/range/conversions'
require 'active_support/core_ext/range/overlaps'
require 'active_support/core_ext/range/include_range'
require 'active_support/core_ext/range/blockless_step'

class Range #:nodoc:
  include ActiveSupport::CoreExtensions::Range::Conversions
  include ActiveSupport::CoreExtensions::Range::Overlaps
  include ActiveSupport::CoreExtensions::Range::IncludeRange
  include ActiveSupport::CoreExtensions::Range::BlocklessStep
end
