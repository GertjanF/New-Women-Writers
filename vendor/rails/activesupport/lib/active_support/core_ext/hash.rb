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

%w(keys indifferent_access deep_merge reverse_merge conversions diff slice except).each do |ext|
  require "active_support/core_ext/hash/#{ext}"
end

class Hash #:nodoc:
  include ActiveSupport::CoreExtensions::Hash::Keys
  include ActiveSupport::CoreExtensions::Hash::IndifferentAccess
  include ActiveSupport::CoreExtensions::Hash::DeepMerge
  include ActiveSupport::CoreExtensions::Hash::ReverseMerge
  include ActiveSupport::CoreExtensions::Hash::Conversions
  include ActiveSupport::CoreExtensions::Hash::Diff
  include ActiveSupport::CoreExtensions::Hash::Slice
  include ActiveSupport::CoreExtensions::Hash::Except
end
