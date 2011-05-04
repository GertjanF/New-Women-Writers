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

class Object
  def to_param
    to_s
  end
end

class TrueClass
  def to_param
    self
  end
end

class FalseClass
  def to_param
    self
  end
end

class NilClass
  def to_param
    self
  end
end

class Regexp #:nodoc:
  def number_of_captures
    Regexp.new("|#{source}").match('').captures.length
  end

  def multiline?
    options & MULTILINE == MULTILINE
  end

  class << self
    def optionalize(pattern)
      case unoptionalize(pattern)
        when /\A(.|\(.*\))\Z/ then "#{pattern}?"
        else "(?:#{pattern})?"
      end
    end

    def unoptionalize(pattern)
      [/\A\(\?:(.*)\)\?\Z/, /\A(.|\(.*\))\?\Z/].each do |regexp|
        return $1 if regexp =~ pattern
      end
      return pattern
    end
  end
end
