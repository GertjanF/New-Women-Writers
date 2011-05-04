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
    # Lookup the format class from a mime type reference symbol. Example:
    #
    #   ActiveResource::Formats[:xml]  # => ActiveResource::Formats::XmlFormat
    #   ActiveResource::Formats[:json] # => ActiveResource::Formats::JsonFormat
    def self.[](mime_type_reference)
      ActiveResource::Formats.const_get(mime_type_reference.to_s.camelize + "Format")
    end
  end
end

require 'active_resource/formats/xml_format'
require 'active_resource/formats/json_format'