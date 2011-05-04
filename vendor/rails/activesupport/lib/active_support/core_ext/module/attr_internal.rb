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
  # Declares an attribute reader backed by an internally-named instance variable.
  def attr_internal_reader(*attrs)
    attrs.each do |attr|
      module_eval "def #{attr}() #{attr_internal_ivar_name(attr)} end"
    end
  end

  # Declares an attribute writer backed by an internally-named instance variable.
  def attr_internal_writer(*attrs)
    attrs.each do |attr|
      module_eval "def #{attr}=(v) #{attr_internal_ivar_name(attr)} = v end"
    end
  end

  # Declares an attribute reader and writer backed by an internally-named instance
  # variable.
  def attr_internal_accessor(*attrs)
    attr_internal_reader(*attrs)
    attr_internal_writer(*attrs)
  end

  alias_method :attr_internal, :attr_internal_accessor

  private
    mattr_accessor :attr_internal_naming_format
    self.attr_internal_naming_format = '@_%s'

    def attr_internal_ivar_name(attr)
      attr_internal_naming_format % attr
    end
end
