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

require 'rubygems'
require 'rubygems/installer'

module Rails
  
  # this class hijacks the functionality of Gem::Installer by overloading its 
  # initializer to only provide the information needed by 
  # Gem::Installer#build_extensions (which happens to be what we have)
  class GemBuilder < Gem::Installer

    def initialize(spec, gem_dir)
      @spec    = spec
      @gem_dir = gem_dir
    end

    # silence the underlying builder
    def say(message)
    end

  end
end
