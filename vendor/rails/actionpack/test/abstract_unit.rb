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

$:.unshift(File.dirname(__FILE__) + '/../lib')
$:.unshift(File.dirname(__FILE__) + '/../../activesupport/lib')
$:.unshift(File.dirname(__FILE__) + '/fixtures/helpers')
$:.unshift(File.dirname(__FILE__) + '/fixtures/alternate_helpers')

require 'rubygems'
require 'yaml'
require 'stringio'
require 'test/unit'

gem 'mocha', '>= 0.9.7'
require 'mocha'

begin
  require 'ruby-debug'
  Debugger.settings[:autoeval] = true
  Debugger.start
rescue LoadError
  # Debugging disabled. `gem install ruby-debug` to enable.
end

require 'action_controller'
require 'action_controller/cgi_ext'
require 'action_controller/test_process'
require 'action_view/test_case'

# Show backtraces for deprecated behavior for quicker cleanup.
ActiveSupport::Deprecation.debug = true

ActionController::Base.logger = nil
ActionController::Routing::Routes.reload rescue nil

ActionController::Base.session_store = nil

# Register danish language for testing
I18n.backend.store_translations 'da', {}
I18n.backend.store_translations 'pt-BR', {}
ORIGINAL_LOCALES = I18n.available_locales.map(&:to_s).sort

FIXTURE_LOAD_PATH = File.join(File.dirname(__FILE__), 'fixtures')
ActionView::Base.cache_template_loading = true
ActionController::Base.view_paths = FIXTURE_LOAD_PATH
CACHED_VIEW_PATHS = ActionView::Base.cache_template_loading? ?
                      ActionController::Base.view_paths :
                      ActionController::Base.view_paths.map {|path| ActionView::Template::EagerPath.new(path.to_s)}

class DummyMutex
  def lock
    @locked = true
  end

  def unlock
    @locked = false
  end

  def locked?
    @locked
  end
end

ActionController::Reloader.default_lock = DummyMutex.new