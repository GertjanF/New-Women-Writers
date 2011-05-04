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

require 'tzinfo/info_timezone'

module TZInfo

  # A Timezone based on a DataTimezoneInfo.
  class DataTimezone < InfoTimezone #:nodoc:
    
    # Returns the TimezonePeriod for the given UTC time. utc can either be
    # a DateTime, Time or integer timestamp (Time.to_i). Any timezone 
    # information in utc is ignored (it is treated as a UTC time).        
    #
    # If no TimezonePeriod could be found, PeriodNotFound is raised.
    def period_for_utc(utc)
      info.period_for_utc(utc)
    end
    
    # Returns the set of TimezonePeriod instances that are valid for the given
    # local time as an array. If you just want a single period, use 
    # period_for_local instead and specify how abiguities should be resolved.
    # Raises PeriodNotFound if no periods are found for the given time.
    def periods_for_local(local)
      info.periods_for_local(local)
    end    
  end
end
