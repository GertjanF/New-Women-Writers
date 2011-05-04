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

require 'cgi'

module ActionController
  module CgiExt
    # Publicize the CGI's internal input stream so we can lazy-read
    # request.body. Make it writable so we don't have to play $stdin games.
    module Stdinput
      def self.included(base)
        base.class_eval do
          remove_method :stdinput
          attr_accessor :stdinput
        end

        base.alias_method_chain :initialize, :stdinput
      end

      def initialize_with_stdinput(type = nil, stdinput = $stdin)
        @stdinput = stdinput
        @stdinput.set_encoding(Encoding::BINARY) if @stdinput.respond_to?(:set_encoding)
        initialize_without_stdinput(type || 'query')
      end
    end
  end
end
