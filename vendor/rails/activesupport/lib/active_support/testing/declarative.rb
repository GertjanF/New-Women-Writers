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
    module Declarative
      # test "verify something" do
      #   ...
      # end
      def test(name, &block)
        test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
        defined = instance_method(test_name) rescue false
        raise "#{test_name} is already defined in #{self}" if defined
        if block_given?
          define_method(test_name, &block)
        else
          define_method(test_name) do
            flunk "No implementation provided for #{name}"
          end
        end
      end
    end
  end
end
