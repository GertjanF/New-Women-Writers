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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Float #:nodoc:
      module Time
        # Deprication helper methods not available as core_ext is loaded first.
        def years
          ::ActiveSupport::Deprecation.warn(self.class.deprecated_method_warning(:years, "Fractional years are not respected. Convert value to integer before calling #years."), caller)
          years_without_deprecation
        end
        def months
          ::ActiveSupport::Deprecation.warn(self.class.deprecated_method_warning(:months, "Fractional months are not respected. Convert value to integer before calling #months."), caller)
          months_without_deprecation
        end

        def months_without_deprecation
          ActiveSupport::Duration.new(self * 30.days, [[:months, self]])
        end
        alias :month :months
      
        def years_without_deprecation
          ActiveSupport::Duration.new(self * 365.25.days, [[:years, self]])
        end
        alias :year :years
      end
    end
  end
end