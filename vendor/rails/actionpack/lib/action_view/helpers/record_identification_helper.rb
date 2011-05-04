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

module ActionView
  module Helpers
    module RecordIdentificationHelper
      # See ActionController::RecordIdentifier.partial_path -- this is just a delegate to that for convenient access in the view.
      def partial_path(*args, &block)
        ActionController::RecordIdentifier.partial_path(*args, &block)
      end

      # See ActionController::RecordIdentifier.dom_class -- this is just a delegate to that for convenient access in the view.
      def dom_class(*args, &block)
        ActionController::RecordIdentifier.dom_class(*args, &block)
      end

      # See ActionController::RecordIdentifier.dom_id -- this is just a delegate to that for convenient access in the view.
      def dom_id(*args, &block)
        ActionController::RecordIdentifier.dom_id(*args, &block)
      end
    end
  end
end