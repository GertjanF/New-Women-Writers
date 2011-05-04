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

class Module
  # Returns the classes in the current ObjectSpace where this module has been
  # mixed in according to Module#included_modules.
  #
  #   module M
  #   end
  #   
  #   module N
  #     include M
  #   end
  #   
  #   class C
  #     include M
  #   end
  #   
  #   class D < C
  #   end
  #
  #   p M.included_in_classes # => [C, D]
  #
  def included_in_classes
    classes = []
    ObjectSpace.each_object(Class) { |k| classes << k if k.included_modules.include?(self) }

    classes.reverse.inject([]) do |unique_classes, klass| 
      unique_classes << klass unless unique_classes.collect { |k| k.to_s }.include?(klass.to_s)
      unique_classes
    end
  end
end