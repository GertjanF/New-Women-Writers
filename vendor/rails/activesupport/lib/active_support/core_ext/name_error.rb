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

# Add a +missing_name+ method to NameError instances.
class NameError #:nodoc:  
  # Add a method to obtain the missing name from a NameError.
  def missing_name
    $1 if /((::)?([A-Z]\w*)(::[A-Z]\w*)*)$/ =~ message
  end
  
  # Was this exception raised because the given name was missing?
  def missing_name?(name)
    if name.is_a? Symbol
      last_name = (missing_name || '').split('::').last
      last_name == name.to_s
    else
      missing_name == name.to_s
    end
  end
end
