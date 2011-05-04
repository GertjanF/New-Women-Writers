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

require 'tzinfo/data_timezone_info'
require 'tzinfo/linked_timezone_info'

module TZInfo
  
  # TimezoneDefinition is included into Timezone definition modules.
  # TimezoneDefinition provides the methods for defining timezones.
  module TimezoneDefinition #:nodoc:
    # Add class methods to the includee.
    def self.append_features(base)
      super
      base.extend(ClassMethods)
    end
    
    # Class methods for inclusion.
    module ClassMethods #:nodoc:
      # Returns and yields a DataTimezoneInfo object to define a timezone.
      def timezone(identifier)
        yield @timezone = DataTimezoneInfo.new(identifier)
      end
      
      # Defines a linked timezone.
      def linked_timezone(identifier, link_to_identifier)
        @timezone = LinkedTimezoneInfo.new(identifier, link_to_identifier)
      end
      
      # Returns the last TimezoneInfo to be defined with timezone or 
      # linked_timezone.
      def get
        @timezone
      end
    end
  end
end
