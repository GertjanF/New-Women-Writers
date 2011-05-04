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
  class DynamicFinderMatch
    def self.match(method)
      df_match = self.new(method)
      df_match.finder ? df_match : nil
    end

    def initialize(method)
      @finder = :first
      case method.to_s
      when /^find_(all_by|last_by|by)_([_a-zA-Z]\w*)$/
        @finder = :last if $1 == 'last_by'
        @finder = :all if $1 == 'all_by'
        names = $2
      when /^find_by_([_a-zA-Z]\w*)\!$/
        @bang = true
        names = $1
      when /^find_or_(initialize|create)_by_([_a-zA-Z]\w*)$/
        @instantiator = $1 == 'initialize' ? :new : :create
        names = $2
      else
        @finder = nil
      end
      @attribute_names = names && names.split('_and_')
    end

    attr_reader :finder, :attribute_names, :instantiator

    def finder?
      !@finder.nil? && @instantiator.nil?
    end

    def instantiator?
      @finder == :first && !@instantiator.nil?
    end

    def bang?
      @bang
    end
  end
end
