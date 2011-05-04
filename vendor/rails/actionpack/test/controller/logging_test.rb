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

class LoggingController < ActionController::Base
  def show
    render :nothing => true
  end
end

class LoggingTest < ActionController::TestCase
  tests LoggingController

  class MockLogger
    attr_reader :logged
    
    def method_missing(method, *args)
      @logged ||= []
      @logged << args.first
    end
  end

  setup :set_logger

  def test_logging_without_parameters
    get :show
    assert_equal 2, logs.size
    assert_nil logs.detect {|l| l =~ /Parameters/ }
  end

  def test_logging_with_parameters
    get :show, :id => 10
    assert_equal 3, logs.size

    params = logs.detect {|l| l =~ /Parameters/ }
    assert_equal 'Parameters: {"id"=>"10"}', params
  end
  
  private

  def set_logger
    @controller.logger = MockLogger.new
  end
  
  def logs
    @logs ||= @controller.logger.logged.compact.map {|l| l.strip}
  end
end
