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

require 'tzinfo/timezone_info'

module TZInfo
  # Represents a linked timezone defined in a data module.
  class LinkedTimezoneInfo < TimezoneInfo #:nodoc:
        
    # The zone that provides the data (that this zone is an alias for).
    attr_reader :link_to_identifier
    
    # Constructs a new TimezoneInfo with an identifier and the identifier
    # of the zone linked to.
    def initialize(identifier, link_to_identifier)
      super(identifier)
      @link_to_identifier = link_to_identifier      
    end
    
    # Returns internal object state as a programmer-readable string.
    def inspect
      "#<#{self.class}: #@identifier,#@link_to_identifier>"
    end
  end
end
