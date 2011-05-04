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

module ActionController
  module Assertions
    module DomAssertions
      # Test two HTML strings for equivalency (e.g., identical up to reordering of attributes)
      #
      # ==== Examples
      #
      #   # assert that the referenced method generates the appropriate HTML string
      #   assert_dom_equal '<a href="http://www.example.com">Apples</a>', link_to("Apples", "http://www.example.com")
      #
      def assert_dom_equal(expected, actual, message = "")
        clean_backtrace do
          expected_dom = HTML::Document.new(expected).root
          actual_dom   = HTML::Document.new(actual).root
          full_message = build_message(message, "<?> expected to be == to\n<?>.", expected_dom.to_s, actual_dom.to_s)

          assert_block(full_message) { expected_dom == actual_dom }
        end
      end
      
      # The negated form of +assert_dom_equivalent+.
      #
      # ==== Examples
      #
      #   # assert that the referenced method does not generate the specified HTML string
      #   assert_dom_not_equal '<a href="http://www.example.com">Apples</a>', link_to("Oranges", "http://www.example.com")
      #
      def assert_dom_not_equal(expected, actual, message = "")
        clean_backtrace do
          expected_dom = HTML::Document.new(expected).root
          actual_dom   = HTML::Document.new(actual).root
          full_message = build_message(message, "<?> expected to be != to\n<?>.", expected_dom.to_s, actual_dom.to_s)

          assert_block(full_message) { expected_dom != actual_dom }
        end
      end
    end
  end
end
