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

module Kernel
  unless respond_to?(:debugger)
    # Starts a debugging session if ruby-debug has been loaded (call script/server --debugger to do load it).
    def debugger
      message = "\n***** Debugger requested, but was not available: Start server with --debugger to enable *****\n"
      defined?(Rails) ? Rails.logger.info(message) : $stderr.puts(message)
    end
  end

  def breakpoint
    message = "\n***** The 'breakpoint' command has been renamed 'debugger' -- please change *****\n"
    defined?(Rails) ? Rails.logger.info(message) : $stderr.puts(message)
    debugger
  end
end
