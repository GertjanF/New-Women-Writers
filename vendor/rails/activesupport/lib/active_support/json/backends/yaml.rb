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

require 'active_support/core_ext/string/starts_ends_with'

module ActiveSupport
  module JSON
    unless const_defined?(:ParseError)
      class ParseError < StandardError
      end
    end

    module Backends
      module Yaml
        extend self

        # Converts a JSON string into a Ruby object.
        def decode(json)
          YAML.load(convert_json_to_yaml(json))
        rescue ArgumentError => e
          raise ParseError, "Invalid JSON string"
        end

        protected
          # Ensure that ":" and "," are always followed by a space
          def convert_json_to_yaml(json) #:nodoc:
            require 'strscan' unless defined? ::StringScanner
            scanner, quoting, marks, pos, times = ::StringScanner.new(json), false, [], nil, []
            while scanner.scan_until(/(\\['"]|['":,\\]|\\.)/)
              case char = scanner[1]
              when '"', "'"
                if !quoting
                  quoting = char
                  pos = scanner.pos
                elsif quoting == char
                  if json[pos..scanner.pos-2] =~ DATE_REGEX
                    # found a date, track the exact positions of the quotes so we can remove them later.
                    # oh, and increment them for each current mark, each one is an extra padded space that bumps
                    # the position in the final YAML output
                    total_marks = marks.size
                    times << pos+total_marks << scanner.pos+total_marks
                  end
                  quoting = false
                end
              when ":",","
                marks << scanner.pos - 1 unless quoting
              when "\\"
                scanner.skip(/\\/)
              end
            end

            if marks.empty?
              json.gsub(/\\([\\\/]|u[[:xdigit:]]{4})/) do
                ustr = $1
                if ustr.start_with?('u')
                  [ustr[1..-1].to_i(16)].pack("U")
                elsif ustr == '\\'
                  '\\\\'
                else
                  ustr
                end
              end
            else
              left_pos  = [-1].push(*marks)
              right_pos = marks << scanner.pos + scanner.rest_size
              output    = []
              left_pos.each_with_index do |left, i|
                scanner.pos = left.succ
                output << scanner.peek(right_pos[i] - scanner.pos + 1).gsub(/\\([\\\/]|u[[:xdigit:]]{4})/) do
                  ustr = $1
                  if ustr.start_with?('u')
                    [ustr[1..-1].to_i(16)].pack("U")
                  elsif ustr == '\\'
                    '\\\\'
                  else
                    ustr
                  end
                end
              end
              output = output * " "

              times.each { |i| output[i-1] = ' ' }
              output.gsub!(/\\\//, '/')
              output
            end
          end
      end
    end
  end
end

