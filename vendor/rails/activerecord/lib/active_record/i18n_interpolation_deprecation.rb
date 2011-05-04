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

# Deprecates the use of the former message interpolation syntax in activerecord
# as in "must have %d characters". The new syntax uses explicit variable names
# as in "{{value}} must have {{count}} characters".

require 'i18n/backend/simple'
module I18n
  module Backend
    class Simple
      DEPRECATED_INTERPOLATORS = { '%d' => '{{count}}', '%s' => '{{value}}' }

      protected
        def interpolate_with_deprecated_syntax(locale, string, values = {})
          return string unless string.is_a?(String) && !values.empty?

          string = string.gsub(/%d|%s/) do |s|
            instead = DEPRECATED_INTERPOLATORS[s]
            ActiveSupport::Deprecation.warn "using #{s} in messages is deprecated; use #{instead} instead."
            instead
          end

          interpolate_without_deprecated_syntax(locale, string, values)
        end
        alias_method_chain :interpolate, :deprecated_syntax
    end
  end
end