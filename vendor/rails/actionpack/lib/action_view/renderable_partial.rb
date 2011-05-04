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

module ActionView
  # NOTE: The template that this mixin is being included into is frozen
  # so you cannot set or modify any instance variables
  module RenderablePartial #:nodoc:
    extend ActiveSupport::Memoizable

    def variable_name
      name.sub(/\A_/, '').to_sym
    end
    memoize :variable_name

    def counter_name
      "#{variable_name}_counter".to_sym
    end
    memoize :counter_name

    def render(view, local_assigns = {})
      if defined? ActionController
        ActionController::Base.benchmark("Rendered #{path_without_format_and_extension}", Logger::DEBUG, false) do
          super
        end
      else
        super
      end
    end

    def render_partial(view, object = nil, local_assigns = {}, as = nil)
      object ||= local_assigns[:object] || local_assigns[variable_name]

      if object.nil? && view.respond_to?(:controller)
        ivar = :"@#{variable_name}"
        object =
          if view.controller.instance_variable_defined?(ivar)
            ActiveSupport::Deprecation::DeprecatedObjectProxy.new(
              view.controller.instance_variable_get(ivar),
              "#{ivar} will no longer be implicitly assigned to #{variable_name}")
          end
      end

      # Ensure correct object is reassigned to other accessors
      local_assigns[:object] = local_assigns[variable_name] = object
      local_assigns[as] = object if as

      render_template(view, local_assigns)
    end
  end
end
