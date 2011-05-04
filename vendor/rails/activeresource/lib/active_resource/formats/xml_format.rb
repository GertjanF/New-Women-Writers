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

module ActiveResource
  module Formats
    module XmlFormat
      extend self

      def extension
        "xml"
      end

      def mime_type
        "application/xml"
      end

      def encode(hash, options={})
        hash.to_xml(options)
      end

      def decode(xml)
        from_xml_data(Hash.from_xml(xml))
      end

      private
        # Manipulate from_xml Hash, because xml_simple is not exactly what we
        # want for Active Resource.
        def from_xml_data(data)
          if data.is_a?(Hash) && data.keys.size == 1
            data.values.first
          else
            data
          end
        end
    end
  end
end
