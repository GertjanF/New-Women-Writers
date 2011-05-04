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
require 'stringio'

class ActionController::TestSessionTest < ActiveSupport::TestCase
  
  def test_calling_delete_without_parameters_raises_deprecation_warning_and_calls_to_clear_test_session
    assert_deprecated(/use clear instead/){ ActionController::TestSession.new.delete }
  end
  
  def test_calling_update_without_parameters_raises_deprecation_warning_and_calls_to_clear_test_session
    assert_deprecated(/use replace instead/){ ActionController::TestSession.new.update }
  end
  
  def test_calling_close_raises_deprecation_warning
    assert_deprecated(/sessions should no longer be closed/){ ActionController::TestSession.new.close }
  end
  
  def test_defaults
    session = ActionController::TestSession.new
    assert_equal({}, session.data)
    assert_equal('', session.session_id)
  end
  
  def test_ctor_allows_setting
    session = ActionController::TestSession.new({:one => 'one', :two => 'two'})
    assert_equal('one', session[:one])
    assert_equal('two', session[:two])
  end
  
  def test_setting_session_item_sets_item
    session = ActionController::TestSession.new
    session[:key] = 'value'
    assert_equal('value', session[:key])
  end
  
  def test_calling_delete_removes_item
    session = ActionController::TestSession.new
    session[:key] = 'value'
    assert_equal('value', session[:key])
    session.delete(:key)
    assert_nil(session[:key])
  end
  
  def test_calling_update_with_params_passes_to_attributes
    session = ActionController::TestSession.new()
    session.update('key' => 'value')
    assert_equal('value', session[:key])
  end
  
  def test_clear_emptys_session
    params = {:one => 'one', :two => 'two'}
    session = ActionController::TestSession.new({:one => 'one', :two => 'two'})
    session.clear
    assert_nil(session[:one])
    assert_nil(session[:two])
  end
  
end