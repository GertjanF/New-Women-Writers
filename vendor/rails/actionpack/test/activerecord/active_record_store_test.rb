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

require 'active_record_unit'

class ActiveRecordStoreTest < ActionController::IntegrationTest
  DispatcherApp = ActionController::Dispatcher.new
  SessionApp = ActiveRecord::SessionStore.new(DispatcherApp,
                :key => '_session_id')
  SessionAppWithFixation = ActiveRecord::SessionStore.new(DispatcherApp,
                            :key => '_session_id', :cookie_only => false)

  class TestController < ActionController::Base
    def no_session_access
      head :ok
    end

    def set_session_value
      session[:foo] = params[:foo] || "bar"
      head :ok
    end

    def get_session_value
      render :text => "foo: #{session[:foo].inspect}"
    end

    def get_session_id
      session[:foo]
      render :text => "#{request.session_options[:id]}"
    end

    def call_reset_session
      session[:foo]
      reset_session
      session[:foo] = "baz"
      head :ok
    end

    def rescue_action(e) raise end
  end

  def setup
    ActiveRecord::SessionStore.session_class.create_table!
    @integration_session = open_session(SessionApp)
  end

  def teardown
    ActiveRecord::SessionStore.session_class.drop_table!
  end

  def test_setting_and_getting_session_value
    with_test_route_set do
      get '/set_session_value'
      assert_response :success
      assert cookies['_session_id']

      get '/get_session_value'
      assert_response :success
      assert_equal 'foo: "bar"', response.body

      get '/set_session_value', :foo => "baz"
      assert_response :success
      assert cookies['_session_id']

      get '/get_session_value'
      assert_response :success
      assert_equal 'foo: "baz"', response.body
    end
  end

  def test_getting_nil_session_value
    with_test_route_set do
      get '/get_session_value'
      assert_response :success
      assert_equal 'foo: nil', response.body
    end
  end

  def test_setting_session_value_after_session_reset
    with_test_route_set do
      get '/set_session_value'
      assert_response :success
      assert cookies['_session_id']
      session_id = cookies['_session_id']

      get '/call_reset_session'
      assert_response :success
      assert_not_equal [], headers['Set-Cookie']

      get '/get_session_value'
      assert_response :success
      assert_equal 'foo: "baz"', response.body

      get '/get_session_id'
      assert_response :success
      assert_not_equal session_id, response.body
    end
  end

  def test_getting_session_id
    with_test_route_set do
      get '/set_session_value'
      assert_response :success
      assert cookies['_session_id']
      session_id = cookies['_session_id']

      get '/get_session_id'
      assert_response :success
      assert_equal session_id, response.body
    end
  end

  def test_prevents_session_fixation
    with_test_route_set do
      get '/set_session_value'
      assert_response :success
      assert cookies['_session_id']

      get '/get_session_value'
      assert_response :success
      assert_equal 'foo: "bar"', response.body
      session_id = cookies['_session_id']
      assert session_id

      reset!

      get '/set_session_value', :_session_id => session_id, :foo => "baz"
      assert_response :success
      assert_equal nil, cookies['_session_id']

      get '/get_session_value', :_session_id => session_id
      assert_response :success
      assert_equal 'foo: nil', response.body
      assert_equal nil, cookies['_session_id']
    end
  end

  def test_allows_session_fixation
    @integration_session = open_session(SessionAppWithFixation)

    with_test_route_set do
      get '/set_session_value'
      assert_response :success
      assert cookies['_session_id']

      get '/get_session_value'
      assert_response :success
      assert_equal 'foo: "bar"', response.body
      session_id = cookies['_session_id']
      assert session_id

      reset!
      @integration_session = open_session(SessionAppWithFixation)

      get '/set_session_value', :_session_id => session_id, :foo => "baz"
      assert_response :success
      assert_equal session_id, cookies['_session_id']

      get '/get_session_value', :_session_id => session_id
      assert_response :success
      assert_equal 'foo: "baz"', response.body
      assert_equal session_id, cookies['_session_id']
    end
  end

  private
    def with_test_route_set
      with_routing do |set|
        set.draw do |map|
          map.with_options :controller => "active_record_store_test/test" do |c|
            c.connect "/:action"
          end
        end
        yield
      end
    end
end
