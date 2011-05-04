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

#:stopdoc:
unless Object.respond_to?(:blank?)
  class Object
    # Check first to see if we are in a Rails environment, no need to 
    # define these methods if we are

    # An object is blank if it's nil, empty, or a whitespace string.
    # For example, "", "   ", nil, [], and {} are blank.
    #
    # This simplifies
    #   if !address.nil? && !address.empty?
    # to
    #   if !address.blank?
    def blank?
      if respond_to?(:empty?) && respond_to?(:strip)
        empty? or strip.empty?
      elsif respond_to?(:empty?)
        empty?
      else
        !self
      end
    end
  end

  class NilClass
    def blank?
      true
    end
  end

  class FalseClass
    def blank?
      true
    end
  end

  class TrueClass
    def blank?
      false
    end
  end

  class Array
    alias_method :blank?, :empty?
  end

  class Hash
    alias_method :blank?, :empty?
  end

  class String
    def blank?
      empty? || strip.empty?
    end
  end

  class Numeric
    def blank?
      false
    end
  end
end
#:startdoc: