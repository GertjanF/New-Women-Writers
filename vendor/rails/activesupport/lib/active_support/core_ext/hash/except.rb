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

require 'set'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Return a hash that includes everything but the given keys. This is useful for
      # limiting a set of parameters to everything but a few known toggles:
      #
      #   @person.update_attributes(params[:person].except(:admin))
      module Except
        # Returns a new hash without the given keys.
        def except(*keys)
          dup.except!(*keys)
        end

        # Replaces the hash without the given keys.
        def except!(*keys)
          keys.map! { |key| convert_key(key) } if respond_to?(:convert_key)
          keys.each { |key| delete(key) }
          self
        end
      end
    end
  end
end
