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
  module ConnectionAdapters # :nodoc:
    module Quoting
      # Quotes the column value to help prevent
      # {SQL injection attacks}[http://en.wikipedia.org/wiki/SQL_injection].
      def quote(value, column = nil)
        # records are quoted as their primary key
        return value.quoted_id if value.respond_to?(:quoted_id)

        case value
          when String, ActiveSupport::Multibyte::Chars
            value = value.to_s
            if column && column.type == :binary && column.class.respond_to?(:string_to_binary)
              "#{quoted_string_prefix}'#{quote_string(column.class.string_to_binary(value))}'" # ' (for ruby-mode)
            elsif column && [:integer, :float].include?(column.type)
              value = column.type == :integer ? value.to_i : value.to_f
              value.to_s
            else
              "#{quoted_string_prefix}'#{quote_string(value)}'" # ' (for ruby-mode)
            end
          when NilClass                 then "NULL"
          when TrueClass                then (column && column.type == :integer ? '1' : quoted_true)
          when FalseClass               then (column && column.type == :integer ? '0' : quoted_false)
          when Float, Fixnum, Bignum    then value.to_s
          # BigDecimals need to be output in a non-normalized form and quoted.
          when BigDecimal               then value.to_s('F')
          else
            if value.acts_like?(:date) || value.acts_like?(:time)
              "'#{quoted_date(value)}'"
            else
              "#{quoted_string_prefix}'#{quote_string(value.to_yaml)}'"
            end
        end
      end

      # Quotes a string, escaping any ' (single quote) and \ (backslash)
      # characters.
      def quote_string(s)
        s.gsub(/\\/, '\&\&').gsub(/'/, "''") # ' (for ruby-mode)
      end

      # Quotes the column name. Defaults to no quoting.
      def quote_column_name(column_name)
        column_name
      end

      # Quotes the table name. Defaults to column name quoting.
      def quote_table_name(table_name)
        quote_column_name(table_name)
      end

      def quoted_true
        "'t'"
      end

      def quoted_false
        "'f'"
      end

      def quoted_date(value)
        value.to_s(:db)
      end

      def quoted_string_prefix
        ''
      end
    end
  end
end
