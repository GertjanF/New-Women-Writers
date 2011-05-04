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

require 'abstract_unit'

class ContentTypeController < ActionController::Base
  def render_content_type_from_body
    response.content_type = Mime::RSS
    render :text => "hello world!"
  end

  def render_defaults
    render :text => "hello world!"
  end

  def render_content_type_from_render
    render :text => "hello world!", :content_type => Mime::RSS
  end

  def render_charset_from_body
    response.charset = "utf-16"
    render :text => "hello world!"
  end

  def render_nil_charset_from_body
    response.charset = nil
    render :text => "hello world!"
  end

  def render_default_for_rhtml
  end

  def render_default_for_rxml
  end

  def render_default_for_rjs
  end

  def render_change_for_rxml
    response.content_type = Mime::HTML
    render :action => "render_default_for_rxml"
  end

  def render_default_content_types_for_respond_to
    respond_to do |format|
      format.html { render :text   => "hello world!" }
      format.xml  { render :action => "render_default_content_types_for_respond_to.rhtml" }
      format.js   { render :text   => "hello world!" }
      format.rss  { render :text   => "hello world!", :content_type => Mime::XML }
    end
  end

  def rescue_action(e) raise end
end

class ContentTypeTest < ActionController::TestCase
  tests ContentTypeController

  def setup
    # enable a logger so that (e.g.) the benchmarking stuff runs, so we can get
    # a more accurate simulation of what happens in "real life".
    @controller.logger = Logger.new(nil)
  end

  def test_render_defaults
    get :render_defaults
    assert_equal "utf-8", @response.charset
    assert_equal Mime::HTML, @response.content_type
  end

  def test_render_changed_charset_default
    ContentTypeController.default_charset = "utf-16"
    get :render_defaults
    assert_equal "utf-16", @response.charset
    assert_equal Mime::HTML, @response.content_type
    ContentTypeController.default_charset = "utf-8"
  end

  def test_content_type_from_body
    get :render_content_type_from_body
    assert_equal "application/rss+xml", @response.content_type
    assert_equal "utf-8", @response.charset
  end

  def test_content_type_from_render
    get :render_content_type_from_render
    assert_equal "application/rss+xml", @response.content_type
    assert_equal "utf-8", @response.charset
  end

  def test_charset_from_body
    get :render_charset_from_body
    assert_equal Mime::HTML, @response.content_type
    assert_equal "utf-16", @response.charset
  end

  def test_nil_charset_from_body
    get :render_nil_charset_from_body
    assert_equal Mime::HTML, @response.content_type
    assert_equal "utf-8", @response.charset, @response.headers.inspect
  end

  def test_nil_default_for_rhtml
    ContentTypeController.default_charset = nil
    get :render_default_for_rhtml
    assert_equal Mime::HTML, @response.content_type
    assert_nil @response.charset, @response.headers.inspect
  ensure
    ContentTypeController.default_charset = "utf-8"
  end

  def test_default_for_rhtml
    get :render_default_for_rhtml
    assert_equal Mime::HTML, @response.content_type
    assert_equal "utf-8", @response.charset
  end

  def test_default_for_rxml
    get :render_default_for_rxml
    assert_equal Mime::XML, @response.content_type
    assert_equal "utf-8", @response.charset
  end

  def test_default_for_rjs
    xhr :post, :render_default_for_rjs
    assert_equal Mime::JS, @response.content_type
    assert_equal "utf-8", @response.charset
  end

  def test_change_for_rxml
    get :render_change_for_rxml
    assert_equal Mime::HTML, @response.content_type
    assert_equal "utf-8", @response.charset
  end
end

class AcceptBasedContentTypeTest < ActionController::TestCase

  tests ContentTypeController

  def setup
    ActionController::Base.use_accept_header = true
  end

  def teardown
    ActionController::Base.use_accept_header = false
  end


  def test_render_default_content_types_for_respond_to
    @request.accept = Mime::HTML.to_s
    get :render_default_content_types_for_respond_to
    assert_equal Mime::HTML, @response.content_type

    @request.accept = Mime::JS.to_s
    get :render_default_content_types_for_respond_to
    assert_equal Mime::JS, @response.content_type
  end

  def test_render_default_content_types_for_respond_to_with_template
    @request.accept = Mime::XML.to_s
    get :render_default_content_types_for_respond_to
    assert_equal Mime::XML, @response.content_type
  end

  def test_render_default_content_types_for_respond_to_with_overwrite
    @request.accept = Mime::RSS.to_s
    get :render_default_content_types_for_respond_to
    assert_equal Mime::XML, @response.content_type
  end
end
