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

module ActiveSupport
  module Testing
    module Assertions
      # Test numeric difference between the return value of an expression as a result of what is evaluated
      # in the yielded block.
      #
      #   assert_difference 'Article.count' do
      #     post :create, :article => {...}
      #   end
      #
      # An arbitrary expression is passed in and evaluated.
      #
      #   assert_difference 'assigns(:article).comments(:reload).size' do
      #     post :create, :comment => {...}
      #   end
      #
      # An arbitrary positive or negative difference can be specified. The default is +1.
      #
      #   assert_difference 'Article.count', -1 do
      #     post :delete, :id => ...
      #   end
      #
      # An array of expressions can also be passed in and evaluated.
      #
      #   assert_difference [ 'Article.count', 'Post.count' ], +2 do
      #     post :create, :article => {...}
      #   end
      #
      # A error message can be specified.
      #
      #   assert_difference 'Article.count', -1, "An Article should be destroyed" do
      #     post :delete, :id => ...
      #   end
      def assert_difference(expression, difference = 1, message = nil, &block)
        b = block.send(:binding)
        exps = Array.wrap(expression)
        before = exps.map { |e| eval(e, b) }

        yield

        exps.each_with_index do |e, i|
          error = "#{e.inspect} didn't change by #{difference}"
          error = "#{message}.\n#{error}" if message
          assert_equal(before[i] + difference, eval(e, b), error)
        end
      end

      # Assertion that the numeric result of evaluating an expression is not changed before and after
      # invoking the passed in block.
      #
      #   assert_no_difference 'Article.count' do
      #     post :create, :article => invalid_attributes
      #   end
      #
      # A error message can be specified.
      #
      #   assert_no_difference 'Article.count', "An Article should not be destroyed" do
      #     post :create, :article => invalid_attributes
      #   end
      def assert_no_difference(expression, message = nil, &block)
        assert_difference expression, 0, message, &block
      end
    end
  end
end
