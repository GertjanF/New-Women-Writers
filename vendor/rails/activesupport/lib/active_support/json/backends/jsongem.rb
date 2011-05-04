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

require 'json' unless defined?(JSON)

module ActiveSupport
  module JSON
    ParseError = ::JSON::ParserError unless const_defined?(:ParseError)

    module Backends
      module JSONGem
        extend self

        # Converts a JSON string into a Ruby object.
        def decode(json)
          data = ::JSON.parse(json)
          if ActiveSupport.parse_json_times
            convert_dates_from(data)
          else
            data
          end
        end

      private
        def convert_dates_from(data)
          case data
            when DATE_REGEX
              DateTime.parse(data)
            when Array
              data.map! { |d| convert_dates_from(d) }
            when Hash
              data.each do |key, value|
                data[key] = convert_dates_from(value)
              end
            else data
          end
        end
      end
    end
  end
end