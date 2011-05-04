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
      # Allows for deep merging
      module DeepMerge
        # Returns a new hash with +self+ and +other_hash+ merged recursively.
        def deep_merge(other_hash)
          self.merge(other_hash) do |key, oldval, newval|
            oldval = oldval.to_hash if oldval.respond_to?(:to_hash)
            newval = newval.to_hash if newval.respond_to?(:to_hash)
            oldval.class.to_s == 'Hash' && newval.class.to_s == 'Hash' ? oldval.deep_merge(newval) : newval
          end
        end

        # Returns a new hash with +self+ and +other_hash+ merged recursively.
        # Modifies the receiver in place.
        def deep_merge!(other_hash)
          replace(deep_merge(other_hash))
        end
      end
    end
  end
end
