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

require 'active_support/core_ext/array/access'
require 'active_support/core_ext/array/conversions'
require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/array/grouping'
require 'active_support/core_ext/array/random_access'
require 'active_support/core_ext/array/wrapper'

class Array #:nodoc:
  include ActiveSupport::CoreExtensions::Array::Access
  include ActiveSupport::CoreExtensions::Array::Conversions
  include ActiveSupport::CoreExtensions::Array::ExtractOptions
  include ActiveSupport::CoreExtensions::Array::Grouping
  include ActiveSupport::CoreExtensions::Array::RandomAccess
  extend ActiveSupport::CoreExtensions::Array::Wrapper
end
