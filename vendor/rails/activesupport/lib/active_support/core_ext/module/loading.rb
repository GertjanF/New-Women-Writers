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
  # Returns String#underscore applied to the module name minus trailing classes.
  #
  #   ActiveRecord.as_load_path               # => "active_record"
  #   ActiveRecord::Associations.as_load_path # => "active_record/associations"
  #   ActiveRecord::Base.as_load_path         # => "active_record" (Base is a class)
  #
  # The Kernel module gives an empty string by definition.
  #
  #   Kernel.as_load_path # => ""
  #   Math.as_load_path   # => "math"
  def as_load_path
    if self == Object || self == Kernel
      ''
    elsif is_a? Class
      parent == self ? '' : parent.as_load_path
    else
      name.split('::').collect do |word|
        word.underscore
      end * '/'
    end
  end
end