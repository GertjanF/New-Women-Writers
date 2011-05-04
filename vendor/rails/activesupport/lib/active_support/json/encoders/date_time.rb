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

class DateTime
  # Coerces the datetime to a string for JSON encoding.
  #
  # ISO 8601 format is used if ActiveSupport::JSON::Encoding.use_standard_json_time_format is set.
  #
  # ==== Examples
  #
  #   # With ActiveSupport::JSON::Encoding.use_standard_json_time_format = true
  #   DateTime.civil(2005,2,1,15,15,10).to_json
  #   # => "2005-02-01T15:15:10+00:00"
  #
  #   # With ActiveSupport::JSON::Encoding.use_standard_json_time_format = false
  #   DateTime.civil(2005,2,1,15,15,10).to_json
  #   # => "2005/02/01 15:15:10 +0000"
  def as_json(options = nil)
    if ActiveSupport::JSON::Encoding.use_standard_json_time_format
      xmlschema
    else
      strftime('%Y/%m/%d %H:%M:%S %z')
    end
  end
end
