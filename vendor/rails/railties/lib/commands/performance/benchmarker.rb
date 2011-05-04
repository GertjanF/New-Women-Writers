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

if ARGV.empty?
  puts "Usage: ./script/performance/benchmarker [times] 'Person.expensive_way' 'Person.another_expensive_way' ..."
  exit 1
end

begin
  N = Integer(ARGV.first)
  ARGV.shift
rescue ArgumentError
  N = 1
end

require RAILS_ROOT + '/config/environment'
require 'benchmark'
include Benchmark

# Don't include compilation in the benchmark
ARGV.each { |expression| eval(expression) }

bm(6) do |x|
  ARGV.each_with_index do |expression, idx|
    x.report("##{idx + 1}") { N.times { eval(expression) } }
  end
end 
