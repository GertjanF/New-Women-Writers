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
    module CGI #:nodoc:
      module EscapeSkippingSlashes #:nodoc:
        if RUBY_VERSION >= '1.9'
          def escape_skipping_slashes(str)
            str = str.join('/') if str.respond_to? :join
            str.gsub(/([^ \/a-zA-Z0-9_.-])/n) do
              "%#{$1.unpack('H2' * $1.bytesize).join('%').upcase}"
            end.tr(' ', '+')
          end
        else
          def escape_skipping_slashes(str)
            str = str.join('/') if str.respond_to? :join
            str.gsub(/([^ \/a-zA-Z0-9_.-])/n) do
              "%#{$1.unpack('H2').first.upcase}"
            end.tr(' ', '+')
          end
        end
      end
    end
  end
end
