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

#:stopdoc:
require 'rbconfig'

# Attempts to require anative extension.
# Falls back to pure-ruby version, if it fails.
#
# This uses Config::CONFIG['arch'] from rbconfig.

def require_arch(fname)
  arch = Config::CONFIG['arch']
  begin
    path = File.join("tmail", arch, fname)
    require path
  rescue LoadError => e
    # try pre-built Windows binaries
    if arch =~ /mswin/
      require File.join("tmail", 'mswin32', fname)
    else
      raise e
    end
  end
end


# def require_arch(fname)
#   dext = Config::CONFIG['DLEXT']
#   begin
#     if File.extname(fname) == dext
#       path = fname
#     else
#       path = File.join("tmail","#{fname}.#{dext}")
#     end
#     require path
#   rescue LoadError => e
#     begin
#       arch = Config::CONFIG['arch']
#       path = File.join("tmail", arch, "#{fname}.#{dext}")
#       require path
#     rescue LoadError
#       case path
#       when /i686/
#         path.sub!('i686', 'i586')
#       when /i586/
#         path.sub!('i586', 'i486')
#       when /i486/
#         path.sub!('i486', 'i386')
#       else
#         begin
#           require fname + '.rb'
#         rescue LoadError
#           raise e
#         end
#       end
#       retry
#     end
#   end
# end
#:startdoc: