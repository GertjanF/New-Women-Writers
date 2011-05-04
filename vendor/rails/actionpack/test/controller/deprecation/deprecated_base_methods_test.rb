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

class DeprecatedBaseMethodsTest < ActionController::TestCase
  class Target < ActionController::Base
    def home_url(greeting)
      "http://example.com/#{greeting}"
    end

    def raises_name_error
      this_method_doesnt_exist
    end

    def rescue_action(e) raise e end
  end

  tests Target

  def test_log_error_silences_deprecation_warnings
    get :raises_name_error
  rescue => e
    assert_not_deprecated { @controller.send :log_error, e }
  end

  if defined? Test::Unit::Error
    def test_assertion_failed_error_silences_deprecation_warnings
      get :raises_name_error
    rescue => e
      error = Test::Unit::Error.new('testing ur doodz', e)
      assert_not_deprecated { error.message }
    end
  end
end
