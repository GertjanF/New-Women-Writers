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
    module QueryCache
      class << self
        def included(base)
          base.class_eval do
            alias_method_chain :columns, :query_cache
            alias_method_chain :select_all, :query_cache
          end

          dirties_query_cache base, :insert, :update, :delete
        end

        def dirties_query_cache(base, *method_names)
          method_names.each do |method_name|
            base.class_eval <<-end_code, __FILE__, __LINE__
              def #{method_name}_with_query_dirty(*args)        # def update_with_query_dirty(*args)
                clear_query_cache if @query_cache_enabled       #   clear_query_cache if @query_cache_enabled
                #{method_name}_without_query_dirty(*args)       #   update_without_query_dirty(*args)
              end                                               # end
                                                                #
              alias_method_chain :#{method_name}, :query_dirty  # alias_method_chain :update, :query_dirty
            end_code
          end
        end
      end

      attr_reader :query_cache, :query_cache_enabled

      # Enable the query cache within the block.
      def cache
        old, @query_cache_enabled = @query_cache_enabled, true
        @query_cache ||= {}
        yield
      ensure
        clear_query_cache
        @query_cache_enabled = old
      end

      # Disable the query cache within the block.
      def uncached
        old, @query_cache_enabled = @query_cache_enabled, false
        yield
      ensure
        @query_cache_enabled = old
      end

      # Clears the query cache.
      #
      # One reason you may wish to call this method explicitly is between queries
      # that ask the database to randomize results. Otherwise the cache would see
      # the same SQL query and repeatedly return the same result each time, silently
      # undermining the randomness you were expecting.
      def clear_query_cache
        @query_cache.clear if @query_cache
      end

      def select_all_with_query_cache(*args)
        if @query_cache_enabled
          cache_sql(args.first) { select_all_without_query_cache(*args) }
        else
          select_all_without_query_cache(*args)
        end
      end

      def columns_with_query_cache(*args)
        if @query_cache_enabled
          @query_cache["SHOW FIELDS FROM #{args.first}"] ||= columns_without_query_cache(*args)
        else
          columns_without_query_cache(*args)
        end
      end

      private
        def cache_sql(sql)
          result =
            if @query_cache.has_key?(sql)
              log_info(sql, "CACHE", 0.0)
              @query_cache[sql]
            else
              @query_cache[sql] = yield
            end

          if Array === result
            result.collect { |row| row.dup }
          else
            result.duplicable? ? result.dup : result
          end
        rescue TypeError
          result
        end
    end
  end
end
