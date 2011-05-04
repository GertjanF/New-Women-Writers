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
    module Array #:nodoc:
      module ExtractOptions
        # Extracts options from a set of arguments. Removes and returns the last
        # element in the array if it's a hash, otherwise returns a blank hash.
        #
        #   def options(*args)
        #     args.extract_options!
        #   end
        #
        #   options(1, 2)           # => {}
        #   options(1, 2, :a => :b) # => {:a=>:b}
        def extract_options!
          last.is_a?(::Hash) ? pop : {}
        end
      end
    end
  end
end
