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

# encoding: utf-8

require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/bytesize'
require 'active_support/core_ext/string/conversions'
require 'active_support/core_ext/string/access'
require 'active_support/core_ext/string/starts_ends_with'
require 'active_support/core_ext/string/iterators'
require 'active_support/core_ext/string/multibyte'
require 'active_support/core_ext/string/xchar'
require 'active_support/core_ext/string/filters'
require 'active_support/core_ext/string/behavior'

class String #:nodoc:
  include ActiveSupport::CoreExtensions::String::Access
  include ActiveSupport::CoreExtensions::String::Conversions
  include ActiveSupport::CoreExtensions::String::Filters
  include ActiveSupport::CoreExtensions::String::Inflections
  include ActiveSupport::CoreExtensions::String::StartsEndsWith
  include ActiveSupport::CoreExtensions::String::Iterators
  include ActiveSupport::CoreExtensions::String::Behavior
  include ActiveSupport::CoreExtensions::String::Multibyte
end
