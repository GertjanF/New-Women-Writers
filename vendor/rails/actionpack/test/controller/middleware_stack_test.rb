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

class MiddlewareStackTest < ActiveSupport::TestCase
  class FooMiddleware; end
  class BarMiddleware; end
  class BazMiddleware; end

  def setup
    @stack = ActionController::MiddlewareStack.new
    @stack.use FooMiddleware
    @stack.use BarMiddleware
  end

  test "use should push middleware as class onto the stack" do
    assert_difference "@stack.size" do
      @stack.use BazMiddleware
    end
    assert_equal BazMiddleware, @stack.last.klass
  end

  test "use should push middleware as a string onto the stack" do
    assert_difference "@stack.size" do
      @stack.use "MiddlewareStackTest::BazMiddleware"
    end
    assert_equal BazMiddleware, @stack.last.klass
  end

  test "use should push middleware as a symbol onto the stack" do
    assert_difference "@stack.size" do
      @stack.use :"MiddlewareStackTest::BazMiddleware"
    end
    assert_equal BazMiddleware, @stack.last.klass
  end

  test "use should push middleware class with arguments onto the stack" do
    assert_difference "@stack.size" do
      @stack.use BazMiddleware, true, :foo => "bar"
    end
    assert_equal BazMiddleware, @stack.last.klass
    assert_equal([true, {:foo => "bar"}], @stack.last.args)
  end

  test "insert inserts middleware at the integer index" do
    @stack.insert(1, BazMiddleware)
    assert_equal BazMiddleware, @stack[1].klass
  end

  test "insert_after inserts middleware after the integer index" do
    @stack.insert_after(1, BazMiddleware)
    assert_equal BazMiddleware, @stack[2].klass
  end

  test "insert_before inserts middleware before another middleware class" do
    @stack.insert_before(BarMiddleware, BazMiddleware)
    assert_equal BazMiddleware, @stack[1].klass
  end

  test "insert_after inserts middleware after another middleware class" do
    @stack.insert_after(BarMiddleware, BazMiddleware)
    assert_equal BazMiddleware, @stack[2].klass
  end

  test "swaps one middleware out for another" do
    assert_equal FooMiddleware, @stack[0].klass
    @stack.swap(FooMiddleware, BazMiddleware)
    assert_equal BazMiddleware, @stack[0].klass
  end

  test "active returns all only enabled middleware" do
    assert_no_difference "@stack.active.size" do
      assert_difference "@stack.size" do
        @stack.use BazMiddleware, :if => lambda { false }
      end
    end
  end

  test "lazy evaluates middleware class" do
    assert_difference "@stack.size" do
      @stack.use lambda { BazMiddleware }
    end
    assert_equal BazMiddleware, @stack.last.klass
  end

  test "lazy evaluates middleware arguments" do
    assert_difference "@stack.size" do
      @stack.use BazMiddleware, lambda { :foo }
    end
    assert_equal [:foo], @stack.last.send(:build_args)
  end
end
