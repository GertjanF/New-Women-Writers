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
  # Invokes the method identified by the symbol +method+, passing it any arguments 
  # and/or the block specified, just like the regular Ruby <tt>Object#send</tt> does.
  #
  # *Unlike* that method however, a +NoMethodError+ exception will *not* be raised 
  # and +nil+ will be returned instead, if the receiving object is a +nil+ object or NilClass.
  #
  # ==== Examples
  #
  # Without try
  #   @person && @person.name
  # or
  #   @person ? @person.name : nil
  #
  # With try
  #   @person.try(:name)
  #
  # +try+ also accepts arguments and/or a block, for the method it is trying
  #   Person.try(:find, 1)
  #   @people.try(:collect) {|p| p.name}
  #--
  # This method definition below is for rdoc purposes only. The alias_method call 
  # below overrides it as an optimization since +try+ behaves like +Object#send+,
  # unless called on +NilClass+.
  def try(method, *args, &block)
    send(method, *args, &block)
  end
  remove_method :try
  alias_method :try, :__send__
end

class NilClass
  def try(*args)
    nil
  end
end
