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
  module Testing
    module RepairHelper
      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      module Toolbox
        def self.record_validations(*model_classes)
          model_classes.inject({}) do |repair, klass|
            repair[klass] ||= {}
            [:validate, :validate_on_create, :validate_on_update].each do |callback|
              the_callback = klass.instance_variable_get("@#{callback.to_s}_callbacks")
              repair[klass][callback] = (the_callback.nil? ? nil : the_callback.dup)
            end
            repair
          end
        end

        def self.reset_validations(recorded)
          recorded.each do |klass, repairs|
            [:validate, :validate_on_create, :validate_on_update].each do |callback|
              klass.instance_variable_set("@#{callback.to_s}_callbacks", repairs[callback])
            end
          end
        end
      end

      module ClassMethods
        def repair_validations(*model_classes)
          setup do
            @validation_repairs = ActiveRecord::Testing::RepairHelper::Toolbox.record_validations(*model_classes)
          end
          teardown do
            ActiveRecord::Testing::RepairHelper::Toolbox.reset_validations(@validation_repairs)
          end
        end
      end

      def repair_validations(*model_classes, &block)
        validation_repairs = ActiveRecord::Testing::RepairHelper::Toolbox.record_validations(*model_classes)
        return block.call
      ensure
        ActiveRecord::Testing::RepairHelper::Toolbox.reset_validations(validation_repairs)
      end
    end
  end
end
