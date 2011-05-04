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

module TZInfo
  # Represents an offset defined in a Timezone data file.
  class TimezoneOffsetInfo #:nodoc:
    # The base offset of the timezone from UTC in seconds.
    attr_reader :utc_offset
    
    # The offset from standard time for the zone in seconds (i.e. non-zero if 
    # daylight savings is being observed).
    attr_reader :std_offset
    
    # The total offset of this observance from UTC in seconds 
    # (utc_offset + std_offset).
    attr_reader :utc_total_offset
    
    # The abbreviation that identifies this observance, e.g. "GMT" 
    # (Greenwich Mean Time) or "BST" (British Summer Time) for "Europe/London". The returned identifier is a 
    # symbol.
    attr_reader :abbreviation
    
    # Constructs a new TimezoneOffsetInfo. utc_offset and std_offset are
    # specified in seconds.
    def initialize(utc_offset, std_offset, abbreviation)
      @utc_offset = utc_offset
      @std_offset = std_offset      
      @abbreviation = abbreviation
      
      @utc_total_offset = @utc_offset + @std_offset
    end
    
    # True if std_offset is non-zero.
    def dst?
      @std_offset != 0
    end
    
    # Converts a UTC DateTime to local time based on the offset of this period.
    def to_local(utc)
      TimeOrDateTime.wrap(utc) {|wrapped|
        wrapped + @utc_total_offset
      }
    end
    
    # Converts a local DateTime to UTC based on the offset of this period.
    def to_utc(local)
      TimeOrDateTime.wrap(local) {|wrapped|
        wrapped - @utc_total_offset
      }
    end
    
    # Returns true if and only if toi has the same utc_offset, std_offset
    # and abbreviation as this TimezoneOffsetInfo.
    def ==(toi)
      toi.respond_to?(:utc_offset) && toi.respond_to?(:std_offset) && toi.respond_to?(:abbreviation) &&
        utc_offset == toi.utc_offset && std_offset == toi.std_offset && abbreviation == toi.abbreviation
    end
    
    # Returns true if and only if toi has the same utc_offset, std_offset
    # and abbreviation as this TimezoneOffsetInfo.
    def eql?(toi)
      self == toi
    end
    
    # Returns a hash of this TimezoneOffsetInfo.
    def hash
      utc_offset.hash ^ std_offset.hash ^ abbreviation.hash
    end
    
    # Returns internal object state as a programmer-readable string.
    def inspect
      "#<#{self.class}: #@utc_offset,#@std_offset,#@abbreviation>"
    end
  end
end
