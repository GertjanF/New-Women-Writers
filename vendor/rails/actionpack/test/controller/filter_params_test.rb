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

class FilterParamController < ActionController::Base
end

class FilterParamTest < Test::Unit::TestCase
  def setup
    @controller = FilterParamController.new
  end

  def test_filter_parameters
    assert FilterParamController.respond_to?(:filter_parameter_logging)
    assert !@controller.respond_to?(:filter_parameters)

    FilterParamController.filter_parameter_logging
    assert @controller.respond_to?(:filter_parameters)

    test_hashes = [[{},{},[]],
    [{'foo'=>nil},{'foo'=>nil},[]],
    [{'foo'=>'bar'},{'foo'=>'bar'},[]],
    [{'foo'=>'bar'},{'foo'=>'bar'},%w'food'],
    [{'foo'=>'bar'},{'foo'=>'[FILTERED]'},%w'foo'],
    [{'foo'=>'bar', 'bar'=>'foo'},{'foo'=>'[FILTERED]', 'bar'=>'foo'},%w'foo baz'],
    [{'foo'=>'bar', 'baz'=>'foo'},{'foo'=>'[FILTERED]', 'baz'=>'[FILTERED]'},%w'foo baz'],
    [{'bar'=>{'foo'=>'bar','bar'=>'foo'}},{'bar'=>{'foo'=>'[FILTERED]','bar'=>'foo'}},%w'fo'],
    [{'foo'=>{'foo'=>'bar','bar'=>'foo'}},{'foo'=>'[FILTERED]'},%w'f banana'],
    [{'baz'=>[{'foo'=>'baz'}]}, {'baz'=>[{'foo'=>'[FILTERED]'}]}, %w(foo)],
    [{'baz'=>[{'foo'=>'baz'}, 1, 2, 3]}, {'baz'=>[{'foo'=>'[FILTERED]'}, 1, 2, 3]}, %w(foo)]]

    test_hashes.each do |before_filter, after_filter, filter_words|
      FilterParamController.filter_parameter_logging(*filter_words)
      assert_equal after_filter, @controller.__send__(:filter_parameters, before_filter)

      filter_words.push('blah')
      FilterParamController.filter_parameter_logging(*filter_words) do |key, value|
        value.reverse! if key =~ /bargain/
      end

      before_filter['barg'] = {'bargain'=>'gain', 'blah'=>'bar', 'bar'=>{'bargain'=>{'blah'=>'foo'}}}
      after_filter['barg'] = {'bargain'=>'niag', 'blah'=>'[FILTERED]', 'bar'=>{'bargain'=>{'blah'=>'[FILTERED]'}}}

      assert_equal after_filter, @controller.__send__(:filter_parameters, before_filter)
    end
  end

  def test_filter_parameters_is_protected
    FilterParamController.filter_parameter_logging(:foo)
    assert !FilterParamController.action_methods.include?('filter_parameters')
    assert_raise(NoMethodError) { @controller.filter_parameters([{'password' => '[FILTERED]'}]) }
  end
end
