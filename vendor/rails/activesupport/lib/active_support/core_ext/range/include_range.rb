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
    module Range #:nodoc:
      # Check if a Range includes another Range.
      module IncludeRange
        def self.included(base) #:nodoc:
          base.alias_method_chain :include?, :range
        end

        # Extends the default Range#include? to support range comparisons.
        #  (1..5).include?(1..5) # => true
        #  (1..5).include?(2..3) # => true
        #  (1..5).include?(2..6) # => false
        #
        # The native Range#include? behavior is untouched.
        #  ("a".."f").include?("c") # => true
        #  (5..9).include?(11) # => false
        def include_with_range?(value)
          if value.is_a?(::Range)
            operator = exclude_end? ? :< : :<=
            end_value = value.exclude_end? ? last.succ : last
            include?(value.first) && (value.last <=> end_value).send(operator, 0)
          else
            include_without_range?(value)
          end
        end
      end
    end
  end
end
