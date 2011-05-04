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

require 'date'
require 'time'

class Time
  # Ruby 1.8-cvs and 1.9 define private Time#to_date
  %w(to_date to_datetime).each do |method|
    public method if private_instance_methods.include?(method)
  end

  # Pre-1.9 versions of Ruby have a bug with marshaling Time instances, where utc instances are
  # unmarshaled in the local zone, instead of utc. We're layering behavior on the _dump and _load
  # methods so that utc instances can be flagged on dump, and coerced back to utc on load.
  if RUBY_VERSION < '1.9'
    class << self
      alias_method :_original_load, :_load
      def _load(marshaled_time)
        time = _original_load(marshaled_time)
        utc = time.instance_variable_get('@marshal_with_utc_coercion')
        utc ? time.utc : time
      end
    end
    
    alias_method :_original_dump, :_dump
    def _dump(*args)
      obj = self.frozen? ? self.dup : self
      obj.instance_variable_set('@marshal_with_utc_coercion', utc?)
      obj._original_dump(*args)
    end
  end
end

require 'active_support/core_ext/time/behavior'
require 'active_support/core_ext/time/calculations'
require 'active_support/core_ext/time/conversions'
require 'active_support/core_ext/time/zones'

class Time#:nodoc:
  include ActiveSupport::CoreExtensions::Time::Behavior
  include ActiveSupport::CoreExtensions::Time::Calculations
  include ActiveSupport::CoreExtensions::Time::Conversions
  include ActiveSupport::CoreExtensions::Time::Zones
end
