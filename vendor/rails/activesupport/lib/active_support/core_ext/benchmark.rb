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

require 'benchmark'

class << Benchmark
  # Earlier Ruby had a slower implementation.
  if RUBY_VERSION < '1.8.7'
    remove_method :realtime

    def realtime
      r0 = Time.now
      yield
      r1 = Time.now
      r1.to_f - r0.to_f
    end
  end

  def ms
    1000 * realtime { yield }
  end
end
