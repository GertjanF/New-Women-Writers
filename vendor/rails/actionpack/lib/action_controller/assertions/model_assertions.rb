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
    module ModelAssertions
      # Ensures that the passed record is valid by Active Record standards and
      # returns any error messages if it is not.
      #
      # ==== Examples
      #
      #   # assert that a newly created record is valid
      #   model = Model.new
      #   assert_valid(model)
      #
      def assert_valid(record)
        ::ActiveSupport::Deprecation.warn("assert_valid is deprecated. Use assert record.valid? instead", caller)
        clean_backtrace do
          assert record.valid?, record.errors.full_messages.join("\n")
        end
      end
    end
  end
end
