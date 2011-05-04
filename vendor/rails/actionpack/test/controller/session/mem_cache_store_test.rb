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

# You need to start a memcached server inorder to run these tests
class MemCacheStoreTest < ActionController::IntegrationTest
  class TestController < ActionController::Base
    def no_session_access
      head :ok
    end

    def set_session_value
      session[:foo] = "bar"
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
      session[:bar]
      reset_session
      session[:bar] = "baz"
      head :ok
    end

    def rescue_action(e) raise end
  end

  begin
    DispatcherApp = ActionController::Dispatcher.new
    MemCacheStoreApp = ActionController::Session::MemCacheStore.new(
                         DispatcherApp, :key => '_session_id')


    def setup
      @integration_session = open_session(MemCacheStoreApp)
    end

    def test_setting_and_getting_session_value
      with_test_route_set do
        get '/set_session_value'
        assert_response :success
        assert cookies['_session_id']

        get '/get_session_value'
        assert_response :success
        assert_equal 'foo: "bar"', response.body
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
        assert_equal 'foo: nil', response.body

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
        get '/get_session_value'
        assert_response :success
        assert_equal 'foo: nil', response.body
        session_id = cookies['_session_id']

        reset!

        get '/set_session_value', :_session_id => session_id
        assert_response :success
        assert_equal nil, cookies['_session_id']
      end
    end
  rescue LoadError, RuntimeError
    $stderr.puts "Skipping MemCacheStoreTest tests. Start memcached and try again."
  end

  private
    def with_test_route_set
      with_routing do |set|
        set.draw do |map|
          map.with_options :controller => "mem_cache_store_test/test" do |c|
            c.connect "/:action"
          end
        end
        yield
      end
    end
end
