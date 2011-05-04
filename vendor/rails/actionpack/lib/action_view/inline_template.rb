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

module ActionView #:nodoc:
  class InlineTemplate #:nodoc:
    include Renderable

    attr_reader :source, :extension, :method_segment

    def initialize(source, type = nil)
      @source = source
      @extension = type
      @method_segment = "inline_#{@source.hash.abs}"
    end

    private
      # Always recompile inline templates
      def recompile?
        true
      end
  end
end
