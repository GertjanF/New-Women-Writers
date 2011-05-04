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

# A base class with no predefined methods that tries to behave like Builder's
# BlankSlate in Ruby 1.9. In Ruby pre-1.9, this is actually the
# Builder::BlankSlate class.
#
# Ruby 1.9 introduces BasicObject which differs slightly from Builder's
# BlankSlate that has been used so far. ActiveSupport::BasicObject provides a
# barebones base class that emulates Builder::BlankSlate while still relying on
# Ruby 1.9's BasicObject in Ruby 1.9.
module ActiveSupport
  if defined? ::BasicObject
    class BasicObject < ::BasicObject
      undef_method :==
      undef_method :equal?

      # Let ActiveSupport::BasicObject at least raise exceptions.
      def raise(*args)
        ::Object.send(:raise, *args)
      end
    end
  else
    require 'blankslate'
    BasicObject = BlankSlate
  end
end
