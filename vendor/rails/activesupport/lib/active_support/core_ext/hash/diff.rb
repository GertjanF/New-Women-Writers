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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      module Diff
        # Returns a hash that represents the difference between two hashes.
        #
        # Examples:
        #
        #   {1 => 2}.diff(1 => 2)         # => {}
        #   {1 => 2}.diff(1 => 3)         # => {1 => 2}
        #   {}.diff(1 => 2)               # => {1 => 2}
        #   {1 => 2, 3 => 4}.diff(1 => 2) # => {3 => 4}
        def diff(h2)
          self.dup.delete_if { |k, v| h2[k] == v }.merge(h2.dup.delete_if { |k, v| self.has_key?(k) })
        end
      end
    end
  end
end
