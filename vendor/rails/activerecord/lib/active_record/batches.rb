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

module ActiveRecord
  module Batches # :nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end

    # When processing large numbers of records, it's often a good idea to do
    # so in batches to prevent memory ballooning.
    module ClassMethods
      # Yields each record that was found by the find +options+. The find is
      # performed by find_in_batches with a batch size of 1000 (or as
      # specified by the <tt>:batch_size</tt> option).
      #
      # Example:
      #
      #   Person.find_each(:conditions => "age > 21") do |person|
      #     person.party_all_night!
      #   end
      #
      # Note: This method is only intended to use for batch processing of
      # large amounts of records that wouldn't fit in memory all at once. If
      # you just need to loop over less than 1000 records, it's probably
      # better just to use the regular find methods.
      def find_each(options = {})
        find_in_batches(options) do |records|
          records.each { |record| yield record }
        end

        self
      end

      # Yields each batch of records that was found by the find +options+ as
      # an array. The size of each batch is set by the <tt>:batch_size</tt>
      # option; the default is 1000.
      #
      # You can control the starting point for the batch processing by
      # supplying the <tt>:start</tt> option. This is especially useful if you
      # want multiple workers dealing with the same processing queue. You can
      # make worker 1 handle all the records between id 0 and 10,000 and
      # worker 2 handle from 10,000 and beyond (by setting the <tt>:start</tt>
      # option on that worker).
      #
      # It's not possible to set the order. That is automatically set to
      # ascending on the primary key ("id ASC") to make the batch ordering
      # work. This also mean that this method only works with integer-based
      # primary keys. You can't set the limit either, that's used to control
      # the the batch sizes.
      #
      # Example:
      #
      #   Person.find_in_batches(:conditions => "age > 21") do |group|
      #     sleep(50) # Make sure it doesn't get too crowded in there!
      #     group.each { |person| person.party_all_night! }
      #   end
      def find_in_batches(options = {})
        raise "You can't specify an order, it's forced to be #{batch_order}" if options[:order]
        raise "You can't specify a limit, it's forced to be the batch_size"  if options[:limit]

        start = options.delete(:start).to_i
        batch_size = options.delete(:batch_size) || 1000

        with_scope(:find => options.merge(:order => batch_order, :limit => batch_size)) do
          records = find(:all, :conditions => [ "#{table_name}.#{primary_key} >= ?", start ])

          while records.any?
            yield records

            break if records.size < batch_size
            records = find(:all, :conditions => [ "#{table_name}.#{primary_key} > ?", records.last.id ])
          end
        end
      end
      
      
      private
        def batch_order
          "#{table_name}.#{primary_key} ASC"
        end
    end
  end
end