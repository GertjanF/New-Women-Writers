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

require 'active_support/core_ext/module/inclusion'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/module/attr_internal'
require 'active_support/core_ext/module/attr_accessor_with_default'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/module/introspection'
require 'active_support/core_ext/module/loading'
require 'active_support/core_ext/module/aliasing'
require 'active_support/core_ext/module/model_naming'
require 'active_support/core_ext/module/synchronization'

module ActiveSupport
  module CoreExtensions
    # Various extensions for the Ruby core Module class.
    module Module
      # Nothing here. Only defined for API documentation purposes.
    end
  end
end

class Module
  include ActiveSupport::CoreExtensions::Module
end
