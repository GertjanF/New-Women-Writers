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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Hash #:nodoc:
      # Allows for reverse merging two hashes where the keys in the calling hash take precedence over those
      # in the <tt>other_hash</tt>. This is particularly useful for initializing an option hash with default values:
      #
      #   def setup(options = {})
      #     options.reverse_merge! :size => 25, :velocity => 10
      #   end
      #
      # Using <tt>merge</tt>, the above example would look as follows:
      #
      #   def setup(options = {})
      #     { :size => 25, :velocity => 10 }.merge(options)
      #   end
      #
      # The default <tt>:size</tt> and <tt>:velocity</tt> are only set if the +options+ hash passed in doesn't already
      # have the respective key.
      module ReverseMerge
        # Performs the opposite of <tt>merge</tt>, with the keys and values from the first hash taking precedence over the second.
        def reverse_merge(other_hash)
          other_hash.merge(self)
        end

        # Performs the opposite of <tt>merge</tt>, with the keys and values from the first hash taking precedence over the second.
        # Modifies the receiver in place.
        def reverse_merge!(other_hash)
          replace(reverse_merge(other_hash))
        end

        alias_method :reverse_update, :reverse_merge!
      end
    end
  end
end
