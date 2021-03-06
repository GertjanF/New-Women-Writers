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

module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:
    module Range #:nodoc:
      # Return an array when step is called without a block.
      module BlocklessStep
        def self.included(base) #:nodoc:
          base.alias_method_chain :step, :blockless
        end

        if RUBY_VERSION < '1.9'
          def step_with_blockless(value = 1, &block)
            if block_given?
              step_without_blockless(value, &block)
            else
              returning [] do |array|
                step_without_blockless(value) { |step| array << step }
              end
            end
          end
        else
          def step_with_blockless(value = 1, &block)
            if block_given?
              step_without_blockless(value, &block)
            else
              step_without_blockless(value).to_a
            end
          end
        end
      end
    end
  end
end
