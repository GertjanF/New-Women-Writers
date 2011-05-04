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
  module Associations
    class HasOneAssociation < BelongsToAssociation #:nodoc:
      def initialize(owner, reflection)
        super
        construct_sql
      end

      def create(attrs = {}, replace_existing = true)
        new_record(replace_existing) do |reflection|
          reflection.create_association(attrs)
        end
      end

      def create!(attrs = {}, replace_existing = true)
        new_record(replace_existing) do |reflection|
          reflection.create_association!(attrs)
        end
      end

      def build(attrs = {}, replace_existing = true)
        new_record(replace_existing) do |reflection|
          reflection.build_association(attrs)
        end
      end

      def replace(obj, dont_save = false)
        load_target

        unless @target.nil? || @target == obj
          if dependent? && !dont_save
            case @reflection.options[:dependent]
            when :delete
              @target.delete unless @target.new_record?
              @owner.clear_association_cache
            when :destroy
              @target.destroy unless @target.new_record?
              @owner.clear_association_cache
            when :nullify
              @target[@reflection.primary_key_name] = nil
              @target.save unless @owner.new_record? || @target.new_record?
            end
          else
            @target[@reflection.primary_key_name] = nil
            @target.save unless @owner.new_record? || @target.new_record?
          end
        end

        if obj.nil?
          @target = nil
        else
          raise_on_type_mismatch(obj)
          set_belongs_to_association_for(obj)
          @target = (AssociationProxy === obj ? obj.target : obj)
        end

        @loaded = true

        unless @owner.new_record? or obj.nil? or dont_save
          return (obj.save ? self : false)
        else
          return (obj.nil? ? nil : self)
        end
      end

      protected
        def owner_quoted_id
          if @reflection.options[:primary_key]
            @owner.class.quote_value(@owner.send(@reflection.options[:primary_key]))
          else
            @owner.quoted_id
          end
        end

      private
        def find_target
          @reflection.klass.find(:first, 
            :conditions => @finder_sql,
            :select     => @reflection.options[:select],
            :order      => @reflection.options[:order], 
            :include    => @reflection.options[:include],
            :readonly   => @reflection.options[:readonly]
          )
        end

        def construct_sql
          case
            when @reflection.options[:as]
              @finder_sql = 
                "#{@reflection.quoted_table_name}.#{@reflection.options[:as]}_id = #{owner_quoted_id} AND " +
                "#{@reflection.quoted_table_name}.#{@reflection.options[:as]}_type = #{@owner.class.quote_value(@owner.class.base_class.name.to_s)}"
            else
              @finder_sql = "#{@reflection.quoted_table_name}.#{@reflection.primary_key_name} = #{owner_quoted_id}"
          end
          @finder_sql << " AND (#{conditions})" if conditions
        end
        
        def construct_scope
          create_scoping = {}
          set_belongs_to_association_for(create_scoping)
          { :create => create_scoping }
        end

        def new_record(replace_existing)
          # Make sure we load the target first, if we plan on replacing the existing
          # instance. Otherwise, if the target has not previously been loaded
          # elsewhere, the instance we create will get orphaned.
          load_target if replace_existing
          record = @reflection.klass.send(:with_scope, :create => construct_scope[:create]) do
            yield @reflection
          end

          if replace_existing
            replace(record, true) 
          else
            record[@reflection.primary_key_name] = @owner.id unless @owner.new_record?
            self.target = record
          end

          record
        end
    end
  end
end
