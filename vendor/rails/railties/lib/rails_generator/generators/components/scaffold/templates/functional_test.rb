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

require 'test_helper'

class <%= controller_class_name %>ControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:<%= table_name %>)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create <%= file_name %>" do
    assert_difference('<%= class_name %>.count') do
      post :create, :<%= file_name %> => { }
    end

    assert_redirected_to <%= file_name %>_path(assigns(:<%= file_name %>))
  end

  test "should show <%= file_name %>" do
    get :show, :id => <%= table_name %>(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => <%= table_name %>(:one).to_param
    assert_response :success
  end

  test "should update <%= file_name %>" do
    put :update, :id => <%= table_name %>(:one).to_param, :<%= file_name %> => { }
    assert_redirected_to <%= file_name %>_path(assigns(:<%= file_name %>))
  end

  test "should destroy <%= file_name %>" do
    assert_difference('<%= class_name %>.count', -1) do
      delete :destroy, :id => <%= table_name %>(:one).to_param
    end

    assert_redirected_to <%= table_name %>_path
  end
end
