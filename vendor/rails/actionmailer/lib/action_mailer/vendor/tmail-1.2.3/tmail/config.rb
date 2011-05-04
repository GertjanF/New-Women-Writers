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

  class Config

    def initialize( strict )
      @strict_parse = strict
      @strict_base64decode = strict
    end

    def strict_parse?
      @strict_parse
    end

    attr_writer :strict_parse

    def strict_base64decode?
      @strict_base64decode
    end

    attr_writer :strict_base64decode

    def new_body_port( mail )
      StringPort.new
    end

    alias new_preamble_port  new_body_port
    alias new_part_port      new_body_port
  
  end

  DEFAULT_CONFIG        = Config.new(false)
  DEFAULT_STRICT_CONFIG = Config.new(true)

  def Config.to_config( arg )
    return DEFAULT_STRICT_CONFIG if arg == true
    return DEFAULT_CONFIG        if arg == false
    arg or DEFAULT_CONFIG
  end

end
#:startdoc: