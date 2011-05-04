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

require 'rational'
require 'tzinfo/ruby_core_support'

module TZInfo
  
  # Provides a method for getting Rationals for a timezone offset in seconds.
  # Pre-reduced rationals are returned for all the half-hour intervals between
  # -14 and +14 hours to avoid having to call gcd at runtime.  
  module OffsetRationals #:nodoc:
    @@rational_cache = {
      -50400 => RubyCoreSupport.rational_new!(-7,12), 
      -48600 => RubyCoreSupport.rational_new!(-9,16),
      -46800 => RubyCoreSupport.rational_new!(-13,24),
      -45000 => RubyCoreSupport.rational_new!(-25,48),
      -43200 => RubyCoreSupport.rational_new!(-1,2),
      -41400 => RubyCoreSupport.rational_new!(-23,48),
      -39600 => RubyCoreSupport.rational_new!(-11,24),
      -37800 => RubyCoreSupport.rational_new!(-7,16),
      -36000 => RubyCoreSupport.rational_new!(-5,12),
      -34200 => RubyCoreSupport.rational_new!(-19,48),
      -32400 => RubyCoreSupport.rational_new!(-3,8),
      -30600 => RubyCoreSupport.rational_new!(-17,48),
      -28800 => RubyCoreSupport.rational_new!(-1,3),
      -27000 => RubyCoreSupport.rational_new!(-5,16),
      -25200 => RubyCoreSupport.rational_new!(-7,24),
      -23400 => RubyCoreSupport.rational_new!(-13,48),
      -21600 => RubyCoreSupport.rational_new!(-1,4),
      -19800 => RubyCoreSupport.rational_new!(-11,48),
      -18000 => RubyCoreSupport.rational_new!(-5,24),
      -16200 => RubyCoreSupport.rational_new!(-3,16),
      -14400 => RubyCoreSupport.rational_new!(-1,6),
      -12600 => RubyCoreSupport.rational_new!(-7,48),
      -10800 => RubyCoreSupport.rational_new!(-1,8),
       -9000 => RubyCoreSupport.rational_new!(-5,48),
       -7200 => RubyCoreSupport.rational_new!(-1,12),
       -5400 => RubyCoreSupport.rational_new!(-1,16),
       -3600 => RubyCoreSupport.rational_new!(-1,24),
       -1800 => RubyCoreSupport.rational_new!(-1,48),
           0 => RubyCoreSupport.rational_new!(0,1),
        1800 => RubyCoreSupport.rational_new!(1,48),
        3600 => RubyCoreSupport.rational_new!(1,24),
        5400 => RubyCoreSupport.rational_new!(1,16),
        7200 => RubyCoreSupport.rational_new!(1,12),
        9000 => RubyCoreSupport.rational_new!(5,48),
       10800 => RubyCoreSupport.rational_new!(1,8),
       12600 => RubyCoreSupport.rational_new!(7,48),
       14400 => RubyCoreSupport.rational_new!(1,6),
       16200 => RubyCoreSupport.rational_new!(3,16),
       18000 => RubyCoreSupport.rational_new!(5,24),
       19800 => RubyCoreSupport.rational_new!(11,48),
       21600 => RubyCoreSupport.rational_new!(1,4),
       23400 => RubyCoreSupport.rational_new!(13,48),
       25200 => RubyCoreSupport.rational_new!(7,24),
       27000 => RubyCoreSupport.rational_new!(5,16),
       28800 => RubyCoreSupport.rational_new!(1,3),
       30600 => RubyCoreSupport.rational_new!(17,48),
       32400 => RubyCoreSupport.rational_new!(3,8),
       34200 => RubyCoreSupport.rational_new!(19,48),
       36000 => RubyCoreSupport.rational_new!(5,12),
       37800 => RubyCoreSupport.rational_new!(7,16),
       39600 => RubyCoreSupport.rational_new!(11,24),
       41400 => RubyCoreSupport.rational_new!(23,48),
       43200 => RubyCoreSupport.rational_new!(1,2),
       45000 => RubyCoreSupport.rational_new!(25,48),
       46800 => RubyCoreSupport.rational_new!(13,24),
       48600 => RubyCoreSupport.rational_new!(9,16),
       50400 => RubyCoreSupport.rational_new!(7,12)}
    
    # Returns a Rational expressing the fraction of a day that offset in 
    # seconds represents (i.e. equivalent to Rational(offset, 86400)). 
    def rational_for_offset(offset)
      @@rational_cache[offset] || Rational(offset, 86400)      
    end
    module_function :rational_for_offset
  end
end
