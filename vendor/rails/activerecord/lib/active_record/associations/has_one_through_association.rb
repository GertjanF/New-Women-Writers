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
    class HasOneThroughAssociation < HasManyThroughAssociation

      def create_through_record(new_value) #nodoc:
        klass = @reflection.through_reflection.klass

        current_object = @owner.send(@reflection.through_reflection.name)

        if current_object
          new_value ? current_object.update_attributes(construct_join_attributes(new_value)) : current_object.destroy
        elsif new_value
          if @owner.new_record?
            self.target = new_value
            through_association = @owner.send(:association_instance_get, @reflection.through_reflection.name)
            through_association.build(construct_join_attributes(new_value))
          else
            @owner.send(@reflection.through_reflection.name, klass.create(construct_join_attributes(new_value)))
          end
        end
      end

    private
      def find(*args)
        super(args.merge(:limit => 1))
      end

      def find_target
        super.first
      end

      def reset_target!
        @target = nil
      end
    end
  end
end
