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

if RUBY_VERSION >= '1.9'
  require 'uri'

  str = "\xE6\x97\xA5\xE6\x9C\xAC\xE8\xAA\x9E" # Ni-ho-nn-go in UTF-8, means Japanese.
  str.force_encoding(Encoding::UTF_8) if str.respond_to?(:force_encoding)

  unless str == URI.unescape(URI.escape(str))
    URI::Parser.class_eval do
      remove_method :unescape
      def unescape(str, escaped = @regexp[:ESCAPED])
        enc = (str.encoding == Encoding::US_ASCII) ? Encoding::UTF_8 : str.encoding
        str.gsub(escaped) { [$&[1, 2].hex].pack('C') }.force_encoding(enc)
      end
    end
  end
end
