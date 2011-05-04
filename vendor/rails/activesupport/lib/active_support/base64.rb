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

begin
  require 'base64'
rescue LoadError
end

module ActiveSupport
  if defined? ::Base64
    Base64 = ::Base64
  else
    # Base64 provides utility methods for encoding and de-coding binary data 
    # using a base 64 representation. A base 64 representation of binary data
    # consists entirely of printable US-ASCII characters. The Base64 module
    # is included in Ruby 1.8, but has been removed in Ruby 1.9.
    module Base64
      # Encodes a string to its base 64 representation. Each 60 characters of
      # output is separated by a newline character.
      #
      #  ActiveSupport::Base64.encode64("Original unencoded string") 
      #  # => "T3JpZ2luYWwgdW5lbmNvZGVkIHN0cmluZw==\n"
      def self.encode64(data)
        [data].pack("m")
      end

      # Decodes a base 64 encoded string to its original representation.
      #
      #  ActiveSupport::Base64.decode64("T3JpZ2luYWwgdW5lbmNvZGVkIHN0cmluZw==") 
      #  # => "Original unencoded string"
      def self.decode64(data)
        data.unpack("m").first
      end
    end
  end
end
