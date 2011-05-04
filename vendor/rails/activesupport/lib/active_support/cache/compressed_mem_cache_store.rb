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

module ActiveSupport
  module Cache
    class CompressedMemCacheStore < MemCacheStore
      def read(name, options = nil)
        if value = super(name, (options || {}).merge(:raw => true))
          if raw?(options)
            value
          else
            Marshal.load(ActiveSupport::Gzip.decompress(value))
          end
        end
      end

      def write(name, value, options = nil)
        value = ActiveSupport::Gzip.compress(Marshal.dump(value)) unless raw?(options)
        super(name, value, (options || {}).merge(:raw => true))
      end
    end
  end
end
