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

gem 'rack', '~> 1.0.0'
require 'rack'

module ActionController
  # TODO: Review explicit to see if they will automatically be handled by
  # the initilizer if they are really needed.
  def self.load_all!
    [Base, CGIHandler, CgiRequest, Request, Response, Http::Headers, UrlRewriter, UrlWriter]
  end

  autoload :Base, 'action_controller/base'
  autoload :Benchmarking, 'action_controller/benchmarking'
  autoload :Caching, 'action_controller/caching'
  autoload :Cookies, 'action_controller/cookies'
  autoload :Dispatcher, 'action_controller/dispatcher'
  autoload :Failsafe, 'action_controller/failsafe'
  autoload :Filters, 'action_controller/filters'
  autoload :Flash, 'action_controller/flash'
  autoload :Helpers, 'action_controller/helpers'
  autoload :HttpAuthentication, 'action_controller/http_authentication'
  autoload :Integration, 'action_controller/integration'
  autoload :IntegrationTest, 'action_controller/integration'
  autoload :Layout, 'action_controller/layout'
  autoload :MiddlewareStack, 'action_controller/middleware_stack'
  autoload :MimeResponds, 'action_controller/mime_responds'
  autoload :ParamsParser, 'action_controller/params_parser'
  autoload :PolymorphicRoutes, 'action_controller/polymorphic_routes'
  autoload :RecordIdentifier, 'action_controller/record_identifier'
  autoload :Reloader, 'action_controller/reloader'
  autoload :Request, 'action_controller/request'
  autoload :RequestForgeryProtection, 'action_controller/request_forgery_protection'
  autoload :Rescue, 'action_controller/rescue'
  autoload :Resources, 'action_controller/resources'
  autoload :Response, 'action_controller/response'
  autoload :RewindableInput, 'action_controller/rewindable_input'
  autoload :Routing, 'action_controller/routing'
  autoload :SessionManagement, 'action_controller/session_management'
  autoload :StatusCodes, 'action_controller/status_codes'
  autoload :Streaming, 'action_controller/streaming'
  autoload :TestCase, 'action_controller/test_case'
  autoload :TestProcess, 'action_controller/test_process'
  autoload :Translation, 'action_controller/translation'
  autoload :UploadedFile, 'action_controller/uploaded_file'
  autoload :UploadedStringIO, 'action_controller/uploaded_file'
  autoload :UploadedTempfile, 'action_controller/uploaded_file'
  autoload :UrlRewriter, 'action_controller/url_rewriter'
  autoload :UrlWriter, 'action_controller/url_rewriter'
  autoload :Verification, 'action_controller/verification'

  module Assertions
    autoload :DomAssertions, 'action_controller/assertions/dom_assertions'
    autoload :ModelAssertions, 'action_controller/assertions/model_assertions'
    autoload :ResponseAssertions, 'action_controller/assertions/response_assertions'
    autoload :RoutingAssertions, 'action_controller/assertions/routing_assertions'
    autoload :SelectorAssertions, 'action_controller/assertions/selector_assertions'
    autoload :TagAssertions, 'action_controller/assertions/tag_assertions'
  end

  module Http
    autoload :Headers, 'action_controller/headers'
  end

  module Session
    autoload :AbstractStore, 'action_controller/session/abstract_store'
    autoload :CookieStore, 'action_controller/session/cookie_store'
    autoload :MemCacheStore, 'action_controller/session/mem_cache_store'
  end

  # DEPRECATE: Remove CGI support
  autoload :CgiRequest, 'action_controller/cgi_process'
  autoload :CGIHandler, 'action_controller/cgi_process'
end

autoload :Mime, 'action_controller/mime_type'

autoload :HTML, 'action_controller/vendor/html-scanner'

require 'action_view'
