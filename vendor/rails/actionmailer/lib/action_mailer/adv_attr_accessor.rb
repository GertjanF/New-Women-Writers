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

module ActionMailer
  module AdvAttrAccessor #:nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods #:nodoc:
      def adv_attr_accessor(*names)
        names.each do |name|
          ivar = "@#{name}"

          define_method("#{name}=") do |value|
            instance_variable_set(ivar, value)
          end

          define_method(name) do |*parameters|
            raise ArgumentError, "expected 0 or 1 parameters" unless parameters.length <= 1
            if parameters.empty?
              if instance_variable_names.include?(ivar)
                instance_variable_get(ivar)
              end
            else
              instance_variable_set(ivar, parameters.first)
            end
          end
        end
      end
    end
  end
end
