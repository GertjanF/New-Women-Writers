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
    module Float #:nodoc:
      module Rounding
        def self.included(base) #:nodoc:
          base.class_eval do
            alias_method :round_without_precision, :round
            alias_method :round, :round_with_precision
          end
        end

        # Rounds the float with the specified precision.
        #
        #   x = 1.337
        #   x.round    # => 1
        #   x.round(1) # => 1.3
        #   x.round(2) # => 1.34
        def round_with_precision(precision = nil)
          precision.nil? ? round_without_precision : (self * (10 ** precision)).round / (10 ** precision).to_f
        end
      end
    end
  end
end
