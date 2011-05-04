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

module ActiveSupport
  class ModelName < String
    attr_reader :singular, :plural, :element, :collection, :partial_path
    alias_method :cache_key, :collection

    def initialize(name)
      super
      @singular = ActiveSupport::Inflector.underscore(self).tr('/', '_').freeze
      @plural = ActiveSupport::Inflector.pluralize(@singular).freeze
      @element = ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self)).freeze
      @collection = ActiveSupport::Inflector.tableize(self).freeze
      @partial_path = "#{@collection}/#{@element}".freeze
    end
  end

  module CoreExtensions
    module Module
      # Returns an ActiveSupport::ModelName object for module. It can be
      # used to retrieve all kinds of naming-related information.
      def model_name
        @model_name ||= ::ActiveSupport::ModelName.new(name)
      end
    end
  end
end
