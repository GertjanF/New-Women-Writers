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

module ActiveSupport
  module CoreExtensions
    module Module
      # Encapsulates the common pattern of:
      #
      #   alias_method :foo_without_feature, :foo
      #   alias_method :foo, :foo_with_feature
      #
      # With this, you simply do:
      #
      #   alias_method_chain :foo, :feature
      #
      # And both aliases are set up for you.
      #
      # Query and bang methods (foo?, foo!) keep the same punctuation:
      #
      #   alias_method_chain :foo?, :feature
      #
      # is equivalent to
      #
      #   alias_method :foo_without_feature?, :foo?
      #   alias_method :foo?, :foo_with_feature?
      #
      # so you can safely chain foo, foo?, and foo! with the same feature.
      def alias_method_chain(target, feature)
        # Strip out punctuation on predicates or bang methods since
        # e.g. target?_without_feature is not a valid method name.
        aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
        yield(aliased_target, punctuation) if block_given?

        with_method, without_method = "#{aliased_target}_with_#{feature}#{punctuation}", "#{aliased_target}_without_#{feature}#{punctuation}"

        alias_method without_method, target
        alias_method target, with_method

        case
          when public_method_defined?(without_method)
            public target
          when protected_method_defined?(without_method)
            protected target
          when private_method_defined?(without_method)
            private target
        end
      end

      # Allows you to make aliases for attributes, which includes
      # getter, setter, and query methods.
      #
      # Example:
      #
      #   class Content < ActiveRecord::Base
      #     # has a title attribute
      #   end
      #
      #   class Email < Content
      #     alias_attribute :subject, :title
      #   end
      #
      #   e = Email.find(1)
      #   e.title    # => "Superstars"
      #   e.subject  # => "Superstars"
      #   e.subject? # => true
      #   e.subject = "Megastars"
      #   e.title    # => "Megastars"
      def alias_attribute(new_name, old_name)
        module_eval <<-STR, __FILE__, __LINE__+1
          def #{new_name}; self.#{old_name}; end          # def subject; self.title; end
          def #{new_name}?; self.#{old_name}?; end        # def subject?; self.title?; end
          def #{new_name}=(v); self.#{old_name} = v; end  # def subject=(v); self.title = v; end
        STR
      end
    end
  end
end
