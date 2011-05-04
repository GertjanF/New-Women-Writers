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

require 'active_support/memoizable'

module ActionController
  module Http
    class Headers < ::Hash
      extend ActiveSupport::Memoizable

      def initialize(*args)
         if args.size == 1 && args[0].is_a?(Hash)
           super()
           update(args[0])
         else
           super
         end
       end

      def [](header_name)
        if include?(header_name)
          super
        else
          super(env_name(header_name))
        end
      end

      private
        # Converts a HTTP header name to an environment variable name.
        def env_name(header_name)
          "HTTP_#{header_name.upcase.gsub(/-/, '_')}"
        end
        memoize :env_name
    end
  end
end
