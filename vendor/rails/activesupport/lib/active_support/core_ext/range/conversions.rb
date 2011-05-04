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
      # Getting ranges in different convenient string representations and other objects
      module Conversions
        RANGE_FORMATS = {
          :db => Proc.new { |start, stop| "BETWEEN '#{start.to_s(:db)}' AND '#{stop.to_s(:db)}'" }
        }

        def self.included(base) #:nodoc:
          base.class_eval do
            alias_method :to_default_s, :to_s
            alias_method :to_s, :to_formatted_s
          end
        end
        # Gives a human readable format of the range.
        #
        # ==== Example
        # 
        #   [1..100].to_formatted_s # => "1..100"
        def to_formatted_s(format = :default)
          RANGE_FORMATS[format] ? RANGE_FORMATS[format].call(first, last) : to_default_s
        end
      end
    end
  end
end
