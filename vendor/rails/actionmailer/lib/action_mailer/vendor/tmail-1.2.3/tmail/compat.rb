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
unless Enumerable.method_defined?(:map) 
  module Enumerable #:nodoc:
    alias map collect
  end
end

unless Enumerable.method_defined?(:select)
  module Enumerable #:nodoc:
    alias select find_all
  end
end

unless Enumerable.method_defined?(:reject)
  module Enumerable #:nodoc:
    def reject
      result = []
      each do |i|
        result.push i unless yield(i)
      end
      result
    end
  end
end

unless Enumerable.method_defined?(:sort_by)
  module Enumerable #:nodoc:
    def sort_by
      map {|i| [yield(i), i] }.sort.map {|val, i| i }
    end
  end
end

unless File.respond_to?(:read)
  def File.read(fname) #:nodoc:
    File.open(fname) {|f|
      return f.read
    }
  end
end
#:startdoc: