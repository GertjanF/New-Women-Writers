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

# Legacy TemplateHandler stub
module ActionView
  module TemplateHandlers #:nodoc:
    module Compilable
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def call(template)
          new.compile(template)
        end
      end

      def compile(template)
         raise "Need to implement #{self.class.name}#compile(template)"
       end
    end
  end

  class TemplateHandler
    def self.call(template)
      "#{name}.new(self).render(template, local_assigns)"
    end

    def initialize(view = nil)
      @view = view
    end

    def render(template, local_assigns)
      raise "Need to implement #{self.class.name}#render(template, local_assigns)"
    end
  end
end
