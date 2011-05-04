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
    module String #:nodoc:
      # Additional string tests.
      module StartsEndsWith
        def self.append_features(base)
          if '1.8.7 and up'.respond_to?(:start_with?)
            base.class_eval do
              alias_method :starts_with?, :start_with?
              alias_method :ends_with?, :end_with?
            end
          else
            super
            base.class_eval do
              alias_method :start_with?, :starts_with?
              alias_method :end_with?, :ends_with?
            end
          end
        end

        # Does the string start with the specified +prefix+?
        def starts_with?(prefix)
          prefix = prefix.to_s
          self[0, prefix.length] == prefix
        end

        # Does the string end with the specified +suffix+?
        def ends_with?(suffix)
          suffix = suffix.to_s
          self[-suffix.length, suffix.length] == suffix      
        end
      end
    end
  end
end
