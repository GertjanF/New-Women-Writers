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

# encoding: utf-8

module ActiveSupport #:nodoc:
  module Multibyte #:nodoc:
    if Kernel.const_defined?(:Encoding)
      # Returns a regular expression that matches valid characters in the current encoding
      def self.valid_character
        VALID_CHARACTER[Encoding.default_internal.to_s]
      end
    else
      def self.valid_character
        case $KCODE
        when 'UTF8'
          VALID_CHARACTER['UTF-8']
        when 'SJIS'
          VALID_CHARACTER['Shift_JIS']
        end
      end
    end

    if 'string'.respond_to?(:valid_encoding?)
      # Verifies the encoding of a string
      def self.verify(string)
        string.valid_encoding?
      end
    else
      def self.verify(string)
        if expression = valid_character
          for c in string.split(//)
            return false unless valid_character.match(c)
          end
        end
        true
      end
    end

    # Verifies the encoding of the string and raises an exception when it's not valid
    def self.verify!(string)
      raise EncodingError.new("Found characters with invalid encoding") unless verify(string)
    end

    if 'string'.respond_to?(:force_encoding)
      # Removes all invalid characters from the string.
      #
      # Note: this method is a no-op in Ruby 1.9
      def self.clean(string)
        string
      end
    else
      def self.clean(string)
        if expression = valid_character
          stripped = []; for c in string.split(//)
            stripped << c if valid_character.match(c)
          end; stripped.join
        else
          string
        end
      end
    end
  end
end