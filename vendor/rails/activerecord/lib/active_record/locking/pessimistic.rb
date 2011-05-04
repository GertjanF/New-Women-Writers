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
  module Locking
    # Locking::Pessimistic provides support for row-level locking using
    # SELECT ... FOR UPDATE and other lock types.
    #
    # Pass <tt>:lock => true</tt> to ActiveRecord::Base.find to obtain an exclusive
    # lock on the selected rows:
    #   # select * from accounts where id=1 for update
    #   Account.find(1, :lock => true)
    #
    # Pass <tt>:lock => 'some locking clause'</tt> to give a database-specific locking clause
    # of your own such as 'LOCK IN SHARE MODE' or 'FOR UPDATE NOWAIT'.
    #
    # Example:
    #   Account.transaction do
    #     # select * from accounts where name = 'shugo' limit 1 for update
    #     shugo = Account.find(:first, :conditions => "name = 'shugo'", :lock => true)
    #     yuko = Account.find(:first, :conditions => "name = 'yuko'", :lock => true)
    #     shugo.balance -= 100
    #     shugo.save!
    #     yuko.balance += 100
    #     yuko.save!
    #   end
    #
    # You can also use ActiveRecord::Base#lock! method to lock one record by id.
    # This may be better if you don't need to lock every row. Example:
    #   Account.transaction do
    #     # select * from accounts where ...
    #     accounts = Account.find(:all, :conditions => ...)
    #     account1 = accounts.detect { |account| ... }
    #     account2 = accounts.detect { |account| ... }
    #     # select * from accounts where id=? for update
    #     account1.lock!
    #     account2.lock!
    #     account1.balance -= 100
    #     account1.save!
    #     account2.balance += 100
    #     account2.save!
    #   end
    #
    # Database-specific information on row locking:
    #   MySQL: http://dev.mysql.com/doc/refman/5.1/en/innodb-locking-reads.html
    #   PostgreSQL: http://www.postgresql.org/docs/8.1/interactive/sql-select.html#SQL-FOR-UPDATE-SHARE
    module Pessimistic
      # Obtain a row lock on this record. Reloads the record to obtain the requested
      # lock. Pass an SQL locking clause to append the end of the SELECT statement
      # or pass true for "FOR UPDATE" (the default, an exclusive row lock).  Returns
      # the locked record.
      def lock!(lock = true)
        reload(:lock => lock) unless new_record?
        self
      end
    end
  end
end
