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

module Rails
  module Rack
    class Debugger
      def initialize(app)
        @app = app

        require_library_or_gem 'ruby-debug'
        ::Debugger.start
        ::Debugger.settings[:autoeval] = true if ::Debugger.respond_to?(:settings)
        puts "=> Debugger enabled"
      rescue Exception
        puts "You need to install ruby-debug to run the server in debugging mode. With gems, use 'gem install ruby-debug'"
        exit
      end

      def call(env)
        @app.call(env)
      end
    end
  end
end
