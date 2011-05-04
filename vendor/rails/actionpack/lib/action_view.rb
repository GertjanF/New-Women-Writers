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

begin
  require 'active_support'
rescue LoadError
  activesupport_path = "#{File.dirname(__FILE__)}/../../activesupport/lib"
  if File.directory?(activesupport_path)
    $:.unshift activesupport_path
    require 'active_support'
  end
end

module ActionView
  def self.load_all!
    [Base, InlineTemplate, TemplateError]
  end

  autoload :Base, 'action_view/base'
  autoload :Helpers, 'action_view/helpers'
  autoload :InlineTemplate, 'action_view/inline_template'
  autoload :Partials, 'action_view/partials'
  autoload :PathSet, 'action_view/paths'
  autoload :Renderable, 'action_view/renderable'
  autoload :RenderablePartial, 'action_view/renderable_partial'
  autoload :Template, 'action_view/template'
  autoload :ReloadableTemplate, 'action_view/reloadable_template'
  autoload :TemplateError, 'action_view/template_error'
  autoload :TemplateHandler, 'action_view/template_handler'
  autoload :TemplateHandlers, 'action_view/template_handlers'
  autoload :Helpers, 'action_view/helpers'
end

class ERB
  autoload :Util, 'action_view/erb/util'
end

I18n.load_path << "#{File.dirname(__FILE__)}/action_view/locale/en.yml"
