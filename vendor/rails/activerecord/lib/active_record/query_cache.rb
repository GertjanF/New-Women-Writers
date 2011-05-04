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

module ActiveRecord
  class QueryCache
    module ClassMethods
      # Enable the query cache within the block if Active Record is configured.
      def cache(&block)
        if ActiveRecord::Base.configurations.blank?
          yield
        else
          connection.cache(&block)
        end
      end

      # Disable the query cache within the block if Active Record is configured.
      def uncached(&block)
        if ActiveRecord::Base.configurations.blank?
          yield
        else
          connection.uncached(&block)
        end
      end
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      ActiveRecord::Base.cache do
        @app.call(env)
      end
    end
  end
end
