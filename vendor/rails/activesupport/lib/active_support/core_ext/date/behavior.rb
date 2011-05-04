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

require 'date'

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Date #:nodoc:
      module Behavior
        # Enable more predictable duck-typing on Date-like classes. See
        # Object#acts_like?.
        def acts_like_date?
          true
        end

        # Date memoizes some instance methods using metaprogramming to wrap
        # the methods with one that caches the result in an instance variable.
        #
        # If a Date is frozen but the memoized method hasn't been called, the
        # first call will result in a frozen object error since the memo
        # instance variable is uninitialized.
        #
        # Work around by eagerly memoizing before freezing.
        #
        # Ruby 1.9 uses a preinitialized instance variable so it's unaffected.
        # This hack is as close as we can get to feature detection:
        begin
          ::Date.today.freeze.jd
        rescue => frozen_object_error
          if frozen_object_error.message =~ /frozen/
            def freeze #:nodoc:
              self.class.private_instance_methods(false).each do |m|
                if m.to_s =~ /\A__\d+__\Z/
                  instance_variable_set(:"@#{m}", [send(m)])
                end
              end

              super
            end
          end
        end
      end
    end
  end
end
