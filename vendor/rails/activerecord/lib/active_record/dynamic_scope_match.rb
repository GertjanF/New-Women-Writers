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
  class DynamicScopeMatch
    def self.match(method)
      ds_match = self.new(method)
      ds_match.scope ? ds_match : nil
    end

    def initialize(method)
      @scope = true
      case method.to_s
      when /^scoped_by_([_a-zA-Z]\w*)$/
        names = $1
      else
        @scope = nil
      end
      @attribute_names = names && names.split('_and_')
    end

    attr_reader :scope, :attribute_names

    def scope?
      !@scope.nil?
    end
  end
end
