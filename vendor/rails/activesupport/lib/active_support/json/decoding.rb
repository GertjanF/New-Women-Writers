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

require 'active_support/core_ext/module/attribute_accessors'

module ActiveSupport
  # Look for and parse json strings that look like ISO 8601 times.
  mattr_accessor :parse_json_times

  module JSON
    class << self
      delegate :decode, :to => :backend

      def backend
        self.backend = "Yaml" unless defined?(@backend)
        @backend
      end

      def backend=(name)
        if name.is_a?(Module)
          @backend = name
        else
          require "active_support/json/backends/#{name.to_s.downcase}.rb"
          @backend = ActiveSupport::JSON::Backends::const_get(name)
        end
      end

      def with_backend(name)
        old_backend, self.backend = backend, name
        yield
      ensure
        self.backend = old_backend
      end
    end
  end
end
