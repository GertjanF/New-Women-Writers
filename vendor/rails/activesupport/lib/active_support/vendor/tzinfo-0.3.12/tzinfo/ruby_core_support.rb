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

require 'date'
require 'rational'

module TZInfo
  
  # Methods to support different versions of Ruby.
  module RubyCoreSupport #:nodoc:
  
    # Use Rational.new! for performance reasons in Ruby 1.8.
    # This has been removed from 1.9, but Rational performs better.        
    if Rational.respond_to? :new!
      def self.rational_new!(numerator, denominator = 1)
        Rational.new!(numerator, denominator)
      end
    else
      def self.rational_new!(numerator, denominator = 1)
        Rational(numerator, denominator)
      end
    end
    
    # Ruby 1.8.6 introduced new! and deprecated new0.
    # Ruby 1.9.0 removed new0.
    # We still need to support new0 for older versions of Ruby.
    if DateTime.respond_to? :new!
      def self.datetime_new!(ajd = 0, of = 0, sg = Date::ITALY)
        DateTime.new!(ajd, of, sg)
      end
    else
      def self.datetime_new!(ajd = 0, of = 0, sg = Date::ITALY)
        DateTime.new0(ajd, of, sg)
      end
    end
  end
end