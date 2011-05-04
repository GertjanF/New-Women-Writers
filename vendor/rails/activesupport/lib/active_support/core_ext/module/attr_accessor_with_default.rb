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
  # Declare an attribute accessor with an initial default return value.
  #
  # To give attribute <tt>:age</tt> the initial value <tt>25</tt>:
  #  
  #   class Person
  #     attr_accessor_with_default :age, 25
  #   end
  #
  #   some_person.age
  #   => 25
  #   some_person.age = 26
  #   some_person.age
  #   => 26
  #
  # To give attribute <tt>:element_name</tt> a dynamic default value, evaluated
  # in scope of self:
  #
  #   attr_accessor_with_default(:element_name) { name.underscore } 
  #
  def attr_accessor_with_default(sym, default = nil, &block)
    raise 'Default value or block required' unless !default.nil? || block
    define_method(sym, block_given? ? block : Proc.new { default })
    module_eval(<<-EVAL, __FILE__, __LINE__)
      def #{sym}=(value)                        # def age=(value)
        class << self; attr_reader :#{sym} end  #   class << self; attr_reader :age end
        @#{sym} = value                         #   @age = value
      end                                       # end
    EVAL
  end
end
